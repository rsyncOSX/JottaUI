//
//  ObservableCatalogsforbackup.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import Foundation
import Observation

// Records for paths
struct Paths: Identifiable, Codable {
    var id = UUID()
    var path: String?
}

@Observable @MainActor
final class ObservableCatalogsforbackup {
    private var jsondata: ObservableJSONStatus?
    var paths: [Paths]?

    // Catalog for new backup or sync
    var catalogsforbackup: String = ""
    // Mark number of days since last backup

    func verifycatalogsforbackup(_ path: String) -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: path, isDirectory: nil)
    }

    func excutestatusjson() {
        let arguments = ["status", "--json"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     syncmode: nil,
                                     input: nil,
                                     processtermination: processtermination)
        process.executeProcess()
    }

    func processtermination(_ stringoutput: [String]?, _: Bool) {
        jsondata = ObservableJSONStatus()
        jsondata?.setJSONstring(stringoutput)
        jsondata?.debugJSONdata()
        paths = jsondata?.backups.map { item in
            let path = item.Path
            return Paths(path: path)
        }
    }
}
