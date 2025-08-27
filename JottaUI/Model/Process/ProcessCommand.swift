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
    var processtermination: ([String]?, Bool) -> Void
    var command: String?
    var arguments: [String]?
    var output = [String]()
    var errordiscovered: Bool = false
    var checkforerror = CheckForError()
    var oneargumentisjsonordump: [Bool]?

    // Store inputPipe as a property
    private var inputPipe: Pipe?

    // AsyncSequence handlers
    let sequencefilehandler = NotificationCenter.default.notifications(named: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
    let sequencetermination = NotificationCenter.default.notifications(named: Process.didTerminateNotification, object: nil)
    // Task handlers
    var sequenceFileHandlerTask: Task<Void, Never>?
    var sequenceTerminationTask: Task<Void, Never>?
    // Imidiate input
    private var input: String?
    // Sync mode, used when setup syncmode
    private var syncmode: String?

    func executeProcess() {
        if let command, let arguments, arguments.count > 0 {
            let task = Process()
            task.launchPath = command
            task.arguments = arguments

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            // Create and store inputPipe
            let inputPipe = Pipe()
            self.inputPipe = inputPipe
            task.standardInput = inputPipe

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
                // If you want to send input immediately, write here.
                // Otherwise, wait for the prompt in datahandle.
                if let input, input != "" {
                    inputPipe.fileHandleForWriting.write((input + "\n").data(using: .utf8)!)
                    // Do NOT close fileHandleForWriting unless you are sure no further input is needed
                }
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

                    // Only write to inputPipe if prompt detected

                    if line.contains("Continue sync setup?") {
                        let reply = self.input ?? "yes"
                        self.inputPipe?.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains("Choose error reporting mode") {
                        let reply = self.syncmode ?? "full"
                        self.inputPipe?.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains("Continue sync reset") {
                        let reply = self.input ?? "y"
                        self.inputPipe?.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains("The existing sync folder on jottacloud.com") {
                        let reply = self.input ?? "n"
                        self.inputPipe?.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
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
                await ActorJottaUILogToFile(command: command, stringoutput: output)
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

    func propogateerror(error: Error) {
        SharedReference.shared.errorobject?.alert(error: error)
    }

    init(command: String?,
         arguments: [String]?,
         syncmode: String?,
         input: String?,
         processtermination: @escaping ([String]?, Bool) -> Void)
    {
        self.command = command
        self.arguments = arguments
        if syncmode != nil {
            self.syncmode = syncmode
        } else {
            self.syncmode = nil
        }
        if input != nil {
            self.input = input
        } else {
            self.input = nil
        }
        self.processtermination = processtermination
        oneargumentisjsonordump = arguments?.compactMap { line in
            line.contains("--json") || line.contains("dump") ? true : nil
        }
    }

    convenience init(command: String?,
                     arguments: [String]?)
    {
        let processtermination: ([String]?, Bool) -> Void = { _, _ in
            Logger.process.info("ProcessCommand: You SEE this message only when Process() is terminated")
        }
        self.init(command: command,
                  arguments: arguments,
                  syncmode: nil,
                  input: nil,
                  processtermination: processtermination)
    }

    deinit {
        Logger.process.info("ProcessCommand: DEINIT")
    }
}
