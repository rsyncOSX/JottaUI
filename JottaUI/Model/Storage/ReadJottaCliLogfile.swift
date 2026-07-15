//
//  ReadJottaCliLogfile.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 20.11.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation
import OSLog

struct ReadJottaCliLogfile {
    func readloggfile() throws -> [String]? {
        let fileManager = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logfilepath = SharedConstants().logfilepath
            let logfileString = homepath.appending(logfilepath) + SharedConstants().logname

            guard fileManager.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homelogfilepathURL = URL(fileURLWithPath: homepath.appending(logfilepath))
            let logfileURL = homelogfilepathURL.appendingPathComponent(SharedConstants().logname)
            Logger.process.debugThreadOnly("LogToFile: readloggfile() ")

            let data = try Data(contentsOf: logfileURL)
            let logfile = String(data: data, encoding: .utf8)
            return logfile.map { line in
                line.components(separatedBy: .newlines)
            }
        }
        return nil
    }
}
