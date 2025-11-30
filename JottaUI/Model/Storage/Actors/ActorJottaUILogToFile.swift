//
//  ActorJottaUILogToFile.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 20.11.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable non_optional_string_data_conversion

import Foundation
import OSLog

enum FilesizeError: LocalizedError {
    case toobig

    var errorDescription: String? {
        switch self {
        case .toobig:
            "Logfile is too big\n Please reset file"
        }
    }
}

actor ActorJottaUILogToFile {
    @concurrent
    nonisolated func writeloggfile(_ newlogadata: String, _ reset: Bool) async {
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let homepathlogfileURL = URL(fileURLWithPath: homepath.appending(SharedConstants().logfilepath))
            let logfileURL = homepathlogfileURL.appendingPathComponent(SharedConstants().jottaUIlogfile)

            Logger.process.debugtthreadonly("LogToFile: writeloggfile() ")
            if let logfiledata = await appendloggfileData(newlogadata, reset) {
                do {
                    try logfiledata.write(to: logfileURL)
                    let checker = FileSize()
                    Task {
                        do {
                            if let size = try await checker.filesize() {
                                if Int(truncating: size) > SharedConstants().logfilesize {
                                    throw FilesizeError.toobig
                                }
                            }
                        } catch let e {
                            let error = e
                            await propogateerror(error: error)
                        }
                    }
                } catch let e {
                    let error = e
                    await propogateerror(error: error)
                }
            }
        }
    }

    @concurrent
    nonisolated func readloggfile() async -> [String]? {
        let fm = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logfileString = homepath.appending(SharedConstants().logfilepath) + SharedConstants().jottaUIlogfile
            guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homepathlogfileURL = URL(fileURLWithPath: homepath.appending(SharedConstants().logfilepath))
            let logfileURL = homepathlogfileURL.appendingPathComponent(SharedConstants().jottaUIlogfile)

            Logger.process.info("LogToFile: readloggfile() ")

            do {
                let data = try Data(contentsOf: logfileURL)
                Logger.process.info("LogToFile: read logfile \(logfileURL.path, privacy: .public)")
                let logfile = String(data: data, encoding: .utf8)
                return logfile.map { line in
                    line.components(separatedBy: .newlines)
                }
            } catch let e {
                let error = e
                await propogateerror(error: error)
            }
        }

        return nil
    }

    @concurrent
    private nonisolated func readloggfileasline() async -> String? {
        let fm = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logfileString = homepath.appending(SharedConstants().logfilepath) + SharedConstants().jottaUIlogfile
            guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homepathlogfileURL = URL(fileURLWithPath: homepath.appending(SharedConstants().logfilepath))
            let logfileURL = homepathlogfileURL.appendingPathComponent(SharedConstants().jottaUIlogfile)

            Logger.process.debugtthreadonly("LogToFile: readloggfileasline() ")

            do {
                let data = try Data(contentsOf: logfileURL)
                return String(data: data, encoding: .utf8)

            } catch let e {
                let error = e
                await propogateerror(error: error)
            }
        }

        return nil
    }

    @concurrent
    private nonisolated func appendloggfileData(_ newlogadata: String, _ reset: Bool) async -> Data? {
        let fm = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logfileString = homepath.appending(SharedConstants().logfilepath) + SharedConstants().jottaUIlogfile
            // guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homepathlogfileURL = URL(fileURLWithPath: homepath.appending(SharedConstants().logfilepath))
            let logfileURL = homepathlogfileURL.appendingPathComponent(SharedConstants().jottaUIlogfile)

            Logger.process.debugtthreadonly("LogToFile: appendloggfileData() ")

            if let newdata = newlogadata.data(using: .utf8) {
                do {
                    if reset {
                        // Only return reset string
                        return newdata
                    } else {
                        // Or append any new log data
                        if fm.locationExists(at: logfileString, kind: .file) == true {
                            let data = try Data(contentsOf: logfileURL)
                            var returneddata = data
                            returneddata.append(newdata)
                            return returneddata
                        } else {
                            // Or if first time write logfile ony return new log data
                            return newdata
                        }
                    }
                } catch let e {
                    let error = e
                    await propogateerror(error: error)
                }
            }
        }

        return nil
    }

    private func logging(command _: String, stringoutput: [String]) async {
        var logfile = await readloggfileasline()

        if logfile == nil {
            logfile = stringoutput.joined(separator: "\n")
        } else {
            logfile! += stringoutput.joined(separator: "\n")
        }
        if let logfile {
            await writeloggfile(logfile, false)
        }
    }

    @discardableResult
    init(_ reset: Bool) async {
        if reset {
            // Reset loggfile
            let date = Date().localized_string_from_date()
            let reset = date + ": " + "logfile is reset..." + "\n"
            await writeloggfile(reset, true)
        }
    }

    @discardableResult
    init(_ command: String, _ stringoutput: [String]?) async {
        if let stringoutput {
            await logging(command: command, stringoutput: stringoutput)
        }
    }
    
    @MainActor
    func propogateerror(error: Error) {
            SharedReference.shared.errorobject?.alert(error: error)
    }
}

// swiftlint:enable non_optional_string_data_conversion
