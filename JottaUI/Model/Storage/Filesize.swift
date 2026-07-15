//
//  Filesize.swift
//  JottaUI
//
//  Created by Thomas Evensen on 17/08/2025.
//

import Foundation
import OSLog

struct FileSize {
    @Sendable func filesize() async throws -> NSNumber? {
        let fileManager = FileManager.default
        if let homepath = URL.userHomeDirectoryURLPath?.path() {
            let logDirPath = homepath.appending(SharedConstants().logfilepath)
            let logfileString = logDirPath + SharedConstants().jottaUIlogfile
            guard fileManager.locationExists(at: logfileString, kind: .file) == true else { return nil }

            let logfileURL = URL(fileURLWithPath: logDirPath).appendingPathComponent(SharedConstants().jottaUIlogfile)

            do {
                // Return filesize
                let attributes = try fileManager.attributesOfItem(atPath: logfileURL.path)
                if let filesize = attributes[FileAttributeKey.size] as? NSNumber {
                    return filesize
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
