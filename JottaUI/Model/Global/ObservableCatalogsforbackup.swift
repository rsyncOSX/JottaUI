//
//  ObservableCatalogsforbackup.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import Foundation
import Observation

@Observable @MainActor
final class ObservableCatalogsforbackup {
    
    // Catalog for backup
    var catalogsforbackup: String = ""
    // Mark number of days since last backup
    
    func verifycatalogsforbackup(_ path: String) -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: path, isDirectory: nil)
    }

    func propogateerror(error: Error) {
        SharedReference.shared.errorobject?.alert(error: error)
    }
}
