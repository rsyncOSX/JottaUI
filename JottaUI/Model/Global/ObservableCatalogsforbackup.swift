//
//  ObservableCatalogsforbackup.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import Foundation
import Observation
import ProcessCommand

// Records for paths
struct Catalogs: Identifiable, Codable {
    var id = UUID()
    var path: String?
}

@Observable @MainActor
final class ObservableCatalogsforbackup {
    private var jsondata: ObservableJSONStatus?
    var catalogs: [Catalogs]?

    // Catalog for new backup or sync
    var catalogsforbackup: String = ""
    // Mark number of days since last backup

    func verifycatalogsforbackup(_ path: String) -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: path, isDirectory: nil)
    }

    func excutestatusjson() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processtermination)

        let arguments = ["status", "--json"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     handlers: handlers,
                                     syncmode: nil,
                                     input: nil)
        do {
            try process.executeProcess()
        } catch let e {
            let error = e
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }

    func processtermination(_ stringoutput: [String]?, _: Bool) {
        jsondata = ObservableJSONStatus()
        jsondata?.setJSONstring(stringoutput)
        jsondata?.debugJSONdata()
        catalogs = jsondata?.backups.map { item in
            let path = item.Path
            return Catalogs(path: path)
        }
    }
}
