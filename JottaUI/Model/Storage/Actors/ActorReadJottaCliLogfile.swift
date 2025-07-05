//
//  ActorReadJottaCliLogfile.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 20.11.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable non_optional_string_data_conversion

import Foundation
import OSLog

actor ActorReadJottaCliLogfile {
    @concurrent
    nonisolated func readloggfile() async -> [String]? {
        let path = await Homepath()
        let fm = FileManager.default
        if let homepath = await path.userHomeDirectoryPath {
            let logfilepath = SharedConstants().logfilepath
            let logfileString = homepath.appending(logfilepath) + SharedConstants().logname

            guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homelogfilepathURL = URL(fileURLWithPath: homepath.appending(logfilepath))
            let logfileURL = homelogfilepathURL.appendingPathComponent(SharedConstants().logname)
            Logger.process.info("LogToFile: readloggfile() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")

            do {
                Logger.process.info("LogToFile: read logfile \(logfileURL.path, privacy: .public)")
                let data = try Data(contentsOf: logfileURL)
                let logfile = String(data: data, encoding: .utf8)
                return logfile.map { line in
                    line.components(separatedBy: .newlines)
                }
            } catch let e {
                let error = e
                await path.propogateerror(error: error)
            }
        }

        return nil
    }
}

// swiftlint:enable non_optional_string_data_conversion
