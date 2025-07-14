//
//  ProcessCommand.swift
//  JottaUI
//
//  Created by Thomas Evensen on 15/03/2021.
//

import Combine
import Foundation
import OSLog

@MainActor
final class ProcessCommand {
    // Combine subscribers
    var subscriptons = Set<AnyCancellable>()
    // Process termination and filehandler closures
    var processtermination: ([String]?) -> Void
    // Output
    var output = [String]()
    // Command to be executed, normally rsync
    var command: String?
    // Arguments to command
    var arguments: [String]?
    // Check for error in output
    var errordiscovered: Bool = false
    // Check for error
    var checkforerror = CheckForError()
    // If one of the arguments are ["--json"] skip check for errors
    var oneargumentisjson: [Bool]?

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
            // Combine, subscribe to NSNotification.Name.NSFileHandleDataAvailable
            NotificationCenter.default.publisher(
                for: NSNotification.Name.NSFileHandleDataAvailable)
                .sink { _ in
                    let data = outHandle.availableData
                    if data.count > 0 {
                        if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                            str.enumerateLines { line, _ in
                                if self.errordiscovered == false,
                                   self.oneargumentisjson == nil
                                {
                                    do {
                                        try self.checkforerror.checkforerror(line)
                                    } catch let e {
                                        self.errordiscovered = true
                                        let error = e
                                        self.propogateerror(error: error)
                                    }
                                }

                                self.output.append(line)
                            }
                        }
                        outHandle.waitForDataInBackgroundAndNotify()
                    }
                }.store(in: &subscriptons)
            // Combine, subscribe to Process.didTerminateNotification
            NotificationCenter.default.publisher(
                for: Process.didTerminateNotification)
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                .sink { [self] _ in
                    processtermination(output)
                    if errordiscovered {
                        Task {
                            await ActorJottaUILogToFile(command: command,
                                                        stringoutput: output)
                        }
                    }
                    SharedReference.shared.process = nil
                    Logger.process.info("CommandProcess: process = nil and termination discovered")
                    // Release Combine subscribers
                    subscriptons.removeAll()
                }.store(in: &subscriptons)
            SharedReference.shared.process = task
            do {
                try task.run()
            } catch let e {
                let error = e
                propogateerror(error: error)
            }
            if let launchPath = task.launchPath, let arguments = task.arguments {
                Logger.process.info("CommandProcess: \(launchPath, privacy: .public)")
                Logger.process.info("CommandProcess: \(arguments.joined(separator: "\n"), privacy: .public)")
            }
        } else {
            Logger.process.warning("CommandProcess: no command to executed or arguments = 0")
        }
    }

    func propogateerror(error: Error) {
        SharedReference.shared.errorobject?.alert(error: error)
    }

    init(command: String?,
         arguments: [String]?,
         processtermination: @escaping ([String]?) -> Void)
    {
        self.command = command
        self.arguments = arguments
        self.processtermination = processtermination
        oneargumentisjson = arguments?.compactMap { line in
            line.contains("--json") ? true : nil
        }
    }

    convenience init(command: String?,
                     arguments: [String]?)
    {
        let processtermination: ([String]?) -> Void = { _ in
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
