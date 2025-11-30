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
        let fm = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logfilepath = SharedConstants().logfilepath
            let logfileString = homepath.appending(logfilepath) + SharedConstants().logname

            guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homelogfilepathURL = URL(fileURLWithPath: homepath.appending(logfilepath))
            let logfileURL = homelogfilepathURL.appendingPathComponent(SharedConstants().logname)
            Logger.process.debugtthreadonly("LogToFile: readloggfile() ")

            do {
                let data = try Data(contentsOf: logfileURL)
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
    
    @MainActor
    func propogateerror(error: Error) {
            SharedReference.shared.errorobject?.alert(error: error)
    }
}

// swiftlint:enable non_optional_string_data_conversion
