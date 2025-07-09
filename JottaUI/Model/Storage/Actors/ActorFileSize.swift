//
//  ActorFileSize.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 19/06/2025.
//

import Foundation
import OSLog

actor ActorFileSize {
    // Only logfile is checked for size, URL-file for logfile is evaluated within function

    @concurrent
    nonisolated func filesize() async throws -> NSNumber? {
        let path = Homepath()
        let fm = FileManager.default
        if let homepath = await path.userHomeDirectoryPath {
            let logfilepath = SharedConstants().jottaUIlogfile
            let logfileString = homepath.appending(logfilepath) + SharedConstants().jottaUIlogfile

            guard fm.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let homepathURL = URL(fileURLWithPath: homepath)
            let logfileURL = homepathURL.appendingPathComponent(SharedConstants().jottaUIlogfile)

            do {
                // Return filesize
                if let filesize = try fm.attributesOfItem(atPath: logfileURL.path)[FileAttributeKey.size] as? NSNumber {
                    Logger.process.info("FileChecker: Filesize of logfile \(filesize, privacy: .public)")
                    return filesize
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
