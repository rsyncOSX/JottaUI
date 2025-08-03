//
//  ProcessRsyncObserving.swift
//  JottaUI
//
//  Created by Thomas Evensen on 03/08/2025.
//

import Foundation
import OSLog

@MainActor
final class ProcessCommandObserving {
    // Process termination and filehandler closures
    var processtermination: ([String]?) -> Void
    // Command to be executed
    var command: String?
    // Arguments to command
    var arguments: [String]?
    // Output
    var output = [String]()
    // Check for error
    var errordiscovered: Bool = false
    var checkforerror = CheckForError()
    // Observers
    var notificationsfilehandle: NSObjectProtocol?
    var notificationstermination: NSObjectProtocol?
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

            notificationsfilehandle =
                NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
                                                       object: nil, queue: .main)
                { _ in
                    Task {
                        await self.datahandle(pipe)
                    }
                }

            notificationstermination =
                NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                                       object: task, queue: .main)
                { _ in
                    Task {
                        // Debounce termination for 500 ms
                        try await Task.sleep(seconds: 0.5)
                        await self.termination()
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
                Logger.process.info("ProcessRsyncObserving: \(launchPath, privacy: .public)")
                Logger.process.info("ProcessRsyncObserving: \(arguments.joined(separator: "\n"), privacy: .public)")
            }
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

    /*
     convenience init(arguments: [String]?,
                      config: SynchronizeConfiguration?,
                      processtermination: @escaping ([String]?, Int?) -> Void,
                      filehandler: @escaping (Int) -> Void)
     {
         self.init(arguments: arguments,
                   config: config,
                   processtermination: processtermination,
                   filehandler: filehandler,
                   usefilehandler: true)
     }

     convenience init(arguments: [String]?,
                      config: SynchronizeConfiguration?,
                      processtermination: @escaping ([String]?, Int?) -> Void)
     {
         // To satisfy arguments
         let filehandler: (Int) -> Void = { _ in
             Logger.process.info("ProcessRsyncObserving: You should NOT SEE this message")
         }
         self.init(arguments: arguments,
                   config: config,
                   processtermination: processtermination,
                   filehandler: filehandler,
                   usefilehandler: false)
     }

     */
    convenience init(command: String?,
                     arguments: [String]?)
    {
        let processtermination: ([String]?) -> Void = { _ in
            Logger.process.info("ProcessRsyncObserving: You SEE this message only when Process() is terminated")
        }
        self.init(command: command,
                  arguments: arguments,
                  processtermination: processtermination)
    }

    deinit {
        Logger.process.info("ProcessRsyncObserving: DEINIT")
    }
}

extension ProcessCommandObserving {
    func datahandle(_ pipe: Pipe) async {
        let outHandle = pipe.fileHandleForReading
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
    }

    func termination() async {
        processtermination(output)
        if errordiscovered, let command {
            Task {
                await ActorJottaUILogToFile(command: command,
                                            stringoutput: output)
            }
        }
        SharedReference.shared.process = nil
        NotificationCenter.default.removeObserver(notificationsfilehandle as Any,
                                                  name: NSNotification.Name.NSFileHandleDataAvailable,
                                                  object: nil)
        NotificationCenter.default.removeObserver(notificationstermination as Any,
                                                  name: Process.didTerminateNotification,
                                                  object: nil)
        Logger.process.info("ProcessRsyncObserving: process = nil and termination discovered")
    }
}
