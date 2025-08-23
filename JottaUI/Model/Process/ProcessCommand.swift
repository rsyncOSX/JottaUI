//
//  ProcessCommand.swift
//  JottaUI
//
//  Created by Thomas Evensen on 03/08/2025.
//

import Foundation
import OSLog

@MainActor
final class ProcessCommand {
    // Process termination and filehandler closures
    var processtermination: ([String]?, Bool) -> Void
    // Command to be executed
    var command: String?
    // Arguments to command
    var arguments: [String]?
    // Output
    var output = [String]()
    // Check for error
    var errordiscovered: Bool = false
    var checkforerror = CheckForError()
    // If one of the arguments are ["--json"] skip check for errors
    var oneargumentisjsonordump: [Bool]?

    let sequencefilehandler = NotificationCenter.default.notifications(named: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
    let sequencetermination = NotificationCenter.default.notifications(named: Process.didTerminateNotification, object: nil)
    var sequenceFileHandlerTask: Task<Void, Never>?
    var sequenceTerminationTask: Task<Void, Never>?

    func executeProcess() {
        if let command, let arguments, arguments.count > 0 {
            let task = Process()
            task.launchPath = command
            task.arguments = arguments
            // Pipe for reading output from Process
            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
            let outHandle = pipe.fileHandleForReading
            outHandle.waitForDataInBackgroundAndNotify()

            sequenceFileHandlerTask = Task {
                for await _ in sequencefilehandler {
                    await self.datahandle(pipe)
                }
            }

            sequenceTerminationTask = Task {
                for await _ in sequencetermination {
                    Task {
                        try await Task.sleep(seconds: 0.5)
                        await self.termination()
                    }
                }
            }

            SharedReference.shared.process = task

            do {
                try task.run()
            } catch let e {
                let error = e
                propogateerror(error: error)
            }
            if let launchPath = task.launchPath, let arguments = task.arguments {
                Logger.process.info("ProcessCommand: \(launchPath, privacy: .public)")
                Logger.process.info("ProcessCommand: \(arguments.joined(separator: "\n"), privacy: .public)")
            }
        }
    }

    func propogateerror(error: Error) {
        SharedReference.shared.errorobject?.alert(error: error)
    }

    init(command: String?,
         arguments: [String]?,
         processtermination: @escaping ([String]?, Bool) -> Void)
    {
        self.command = command
        self.arguments = arguments
        self.processtermination = processtermination
        oneargumentisjsonordump = arguments?.compactMap { line in
            line.contains("--json") || line.contains("dump") ? true : nil
        }
    }

    convenience init(command: String?,
                     arguments: [String]?)
    {
        let processtermination: ([String]?, Bool) -> Void = { _,_  in
            Logger.process.info("ProcessCommand: You SEE this message only when Process() is terminated")
        }
        self.init(command: command,
                  arguments: arguments,
                  processtermination: processtermination)
    }

    deinit {
        Logger.process.info("ProcessCommand: DEINIT")
    }
}

extension ProcessCommand {
    func datahandle(_ pipe: Pipe) async {
        let outHandle = pipe.fileHandleForReading
        let data = outHandle.availableData
        if data.count > 0 {
            if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                str.enumerateLines { line, _ in
                    
                    if self.errordiscovered == false, self.oneargumentisjsonordump?.count == 0 {
                        do {
                            try self.checkforerror.checkforerror(line)
                        } catch let e {
                            self.errordiscovered = true
                            let error = e
                            self.propogateerror(error: error)
                        }
                    }
                    self.output.append(line)
                    // Continue sync setup? [yes]:
                    // let argumentssync = ["sync", "setup", "--root", catalogsforbackup]
                    
                    if line.contains("Continue sync setup?") {
                        
                        SharedReference.shared.process?.interrupt()
                        SharedReference.shared.process = nil
                    }
                }
            }
            outHandle.waitForDataInBackgroundAndNotify()
        }
    }

    func termination() async {
        processtermination(output, errordiscovered)
        if errordiscovered, let command {
            Task {
                await ActorJottaUILogToFile(command: command,
                                            stringoutput: output)
            }
        }
        SharedReference.shared.process = nil
        NotificationCenter.default.removeObserver(sequencefilehandler as Any,
                                                  name: NSNotification.Name.NSFileHandleDataAvailable,
                                                  object: nil)
        NotificationCenter.default.removeObserver(sequencetermination as Any,
                                                  name: Process.didTerminateNotification,
                                                  object: nil)
        sequenceFileHandlerTask?.cancel()
        sequenceTerminationTask?.cancel()
        Logger.process.info("ProcessCommand: process = nil and termination discovered")
    }
}
