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
    // Task handlers
    var sequenceFileHandlerTask: Task<Void, Never>?
    var sequenceTerminationTask: Task<Void, Never>?
    // Imidiate input
    private var input: String?
    // Sync mode, used when setup syncmode
    private var syncmode: String?

    var strings: SharedStrings {
        SharedStrings()
    }

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

            // AsyncSequence
            let sequencefilehandler = NotificationCenter.default.notifications(named: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle)
            let sequencetermination = NotificationCenter.default.notifications(named: Process.didTerminateNotification, object: task)

            sequenceFileHandlerTask = Task {
                for await _ in sequencefilehandler {
                    Logger.process.info("ProcessCommand: sequenceFileHandlerTask - handling data")
                    await self.datahandle(pipe)
                }
                // Final drain - keep reading until no more data
                while pipe.fileHandleForReading.availableData.count > 0 {
                    Logger.process.info("ProcessCommand: sequenceFileHandlerTask - drain remaining data")
                    await self.datahandle(pipe)
                }
            }

            sequenceTerminationTask = Task {
                for await _ in sequencetermination {
                    // Small delay to let final data arrive
                    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
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
                Logger.process.info("ProcessCommand: command - \(launchPath, privacy: .public)")
                Logger.process.info("ProcessCommand: arguments - \(arguments.joined(separator: "\n"), privacy: .public)")
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

                    if line.contains(self.strings.continueSyncSetup) {
                        let reply = self.input ?? "yes"
                        pipe.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains(self.strings.chooseErrorReportingMode) {
                        let reply = self.syncmode ?? "full"
                        pipe.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains(self.strings.continueSyncReset) {
                        let reply = self.input ?? "y"
                        pipe.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
                    }

                    if line.contains(self.strings.theExistingSyncFolderOnJottacloudCom) {
                        let reply = self.input ?? "n"
                        pipe.fileHandleForWriting.write((reply + "\n").data(using: .utf8)!)
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
