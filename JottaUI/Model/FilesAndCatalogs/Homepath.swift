//
//  Homepath.swift
//  JottaUI
//
//  Created by Thomas Evensen on 24/06/2024.
//

import Foundation
import OSLog

@MainActor
struct Homepath {
    // full path without macserialnumber
    var fullpathnomacserial: String?
    // Documentscatalog
    var documentscatalog: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        return paths.firstObject as? String
    }

    // Mac serialnumber
    var macserialnumber: String? {
        if SharedReference.shared.macserialnumber == nil {
            SharedReference.shared.macserialnumber = Macserialnumber().getMacSerialNumber()
        }
        return SharedReference.shared.macserialnumber
    }

    var userHomeDirectoryPath: String? {
        let pw = getpwuid(getuid())
        if let home = pw?.pointee.pw_dir {
            let homePath = FileManager.default.string(withFileSystemRepresentation: home, length: Int(strlen(home)))
            return homePath
        } else {
            return nil
        }
    }

    var userHomeDirectoryURLPath: URL? {
        let pw = getpwuid(getuid())
        if let home = pw?.pointee.pw_dir {
            let homePath = FileManager.default.string(withFileSystemRepresentation: home, length: Int(strlen(home)))
            return URL(fileURLWithPath: homePath)
        } else {
            return nil
        }
    }

    func propogateerror(error: Error) {
        SharedReference.shared.errorobject?.alert(error: error)
    }

    init() {
        fullpathnomacserial = (userHomeDirectoryPath ?? "") + SharedConstants().logfilepath
    }
}

extension FileManager {
    func locationExists(at path: String, kind: LocationKind) -> Bool {
        var isFolder: ObjCBool = false

        guard fileExists(atPath: path, isDirectory: &isFolder) else {
            return false
        }

        switch kind {
        case .file: return !isFolder.boolValue
        case .folder: return isFolder.boolValue
        }
    }
}

/// Enum describing various kinds of locations that can be found on a file system.
public enum LocationKind {
    /// A file can be found at the location.
    case file
    /// A folder can be found at the location.
    case folder
}
