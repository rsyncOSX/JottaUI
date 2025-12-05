//
//  AddCatalogsView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import OSLog
import ProcessCommand
import SwiftUI

enum JottaTask: String, CaseIterable, Identifiable, CustomStringConvertible {
    case backup
    case sync
    case select

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase.replacingOccurrences(of: "_", with: " ") }
}

enum SyncMode: String, CaseIterable, Identifiable, CustomStringConvertible {
    case full
    case stackonly
    case off

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase.replacingOccurrences(of: "_", with: " ") }
}

struct AddCatalogsView: View {
    @State private var observablecatalogsforbackup = ObservableCatalogsforbackup()
    @State private var catalogadded: Bool = false
    @State private var jottatask = JottaTask.select
    @State private var syncmode = SyncMode.full
    @State private var errordiscovered: Bool = false
    @State private var selectedcatalog: Catalogs.ID?

    @State private var confirmdelete: Bool = false
    @State private var catalogfordelete: String = ""

    var body: some View {
        Form {
            Section {
                HStack {
                    catalogforbackup

                    OpencatalogView(selecteditem: $observablecatalogsforbackup.catalogsforbackup, catalogs: true)

                    VStack {
                        Picker(NSLocalizedString("Task", comment: ""),
                               selection: $jottatask) {
                            ForEach(JottaTask.allCases) { Text($0.description)
                                .tag($0)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .frame(width: 150)

                        if jottatask == .sync {
                            Picker(NSLocalizedString("Mode", comment: ""),
                                   selection: $syncmode) {
                                ForEach(SyncMode.allCases) { Text($0.description)
                                    .tag($0)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .frame(width: 150)
                        }
                    }

                    Button {
                        let catalogsforbackup = observablecatalogsforbackup.catalogsforbackup

                        let command = FullpathJottaCli().jottaclipathandcommand()
                        if jottatask == .backup {
                            let handlers = CreateCommandHandlers().createcommandhandlers(
                                processtermination: processtermination)
                            let argumentsbackup = ["add", catalogsforbackup]
                            let process = ProcessCommand(command: command,
                                                         arguments: argumentsbackup,
                                                         handlers: handlers,
                                                         syncmode: nil,
                                                         input: nil)
                            // Start progressview
                            do {
                                try process.executeProcess()
                            } catch let e {
                                let error = e
                                SharedReference.shared.errorobject?.alert(error: error)
                            }
                        } else if jottatask == .sync {
                            let handlers = CreateCommandHandlers().createcommandhandlers(
                                processtermination: processtermination)
                            let argumentssync = ["sync", "setup", "--root", catalogsforbackup]
                            let process = ProcessCommand(command: command,
                                                         arguments: argumentssync,
                                                         handlers: handlers,
                                                         syncmode: syncmode.description,
                                                         input: nil)
                            // Start progressview
                            do {
                                try process.executeProcess()
                            } catch let e {
                                let error = e
                                SharedReference.shared.errorobject?.alert(error: error)
                            }
                        }

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .disabled(observablecatalogsforbackup.verifycatalogsforbackup(observablecatalogsforbackup.catalogsforbackup) == false || jottatask == .select)
                    .buttonStyle(RefinedGlassButtonStyle())
                }
            } header: {
                Text("Add catalogs for backup and sync")
            }

            Section {
                Button {
                    observablecatalogsforbackup.catalogs = nil
                    observablecatalogsforbackup.excutestatusjson()

                } label: {
                    Image(systemName: "tablecells.fill")
                        .imageScale(.large)
                }
                .buttonStyle(RefinedGlassButtonStyle())

                Table(observablecatalogsforbackup.catalogs ?? [], selection: $selectedcatalog) {
                    TableColumn("Catalogs") { catalog in
                        Text(catalog.path ?? "")
                    }
                }
                .onChange(of: selectedcatalog) {
                    if let catalogs = observablecatalogsforbackup.catalogs {
                        if let index = catalogs.firstIndex(where: { $0.id == selectedcatalog }) {
                            catalogfordelete = catalogs[index].path ?? ""
                        } else {
                            catalogfordelete = ""
                            selectedcatalog = nil
                        }
                    }
                }
                .padding()
                .confirmationDialog(
                    Text("Delete \(catalogfordelete)?"),
                    isPresented: $confirmdelete
                ) {
                    Button("Delete") {
                        delete()
                        confirmdelete = false
                    }
                    .buttonStyle(RefinedGlassButtonStyle())
                }
                .onDeleteCommand {
                    confirmdelete = true
                }

            } header: {
                if observablecatalogsforbackup.catalogs?.count ?? 0 <= 0 {
                    Text("Catalogs in backup")
                } else {
                    HStack {
                        Text("Catalogs in backup, to delete a catalog select it and press")
                        Text(Image(systemName: "delete.left"))
                    }
                }
            }
        }
        .formStyle(.grouped)
        .confirmationDialog(
            confirmation,
            isPresented: $catalogadded
        ) {
            Button("Close", role: .cancel) {
                observablecatalogsforbackup.catalogsforbackup = ""
                catalogadded = false
            }
            .buttonStyle(RefinedGlassButtonStyle())
        }
    }

    var catalogforbackup: some View {
        EditValueErrorScheme(300, NSLocalizedString(defaultstring, comment: ""),
                             $observablecatalogsforbackup.catalogsforbackup,
                             observablecatalogsforbackup.verifycatalogsforbackup(observablecatalogsforbackup.catalogsforbackup))
            .foregroundColor(observablecatalogsforbackup.verifycatalogsforbackup(observablecatalogsforbackup.catalogsforbackup) ? Color.white : Color.red)
            .onChange(of: observablecatalogsforbackup.catalogsforbackup) {
                Task {
                    guard observablecatalogsforbackup.verifycatalogsforbackup(observablecatalogsforbackup.catalogsforbackup) else {
                        return
                    }
                }
            }
    }

    var confirmation: String {
        if jottatask == .backup {
            "Catalog for BACKUP added"
        } else if jottatask == .sync {
            "Catalog for SYNC added"
        } else {
            "Select a task first"
        }
    }

    var defaultstring: String {
        if jottatask == .backup {
            "Catalog for BACKUP"
        } else if jottatask == .sync {
            "Catalog for SYNC"
        } else {
            "Select a task first"
        }
    }

    func processtermination(_: [String]?, _ errordiscovered: Bool) {
        catalogadded = !errordiscovered
        observablecatalogsforbackup.catalogs = nil
        observablecatalogsforbackup.excutestatusjson()
    }

    func processterminationdelete(_: [String]?, _: Bool) {
        observablecatalogsforbackup.catalogs = nil
        observablecatalogsforbackup.excutestatusjson()
    }

    func delete() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processterminationdelete)
        let command = FullpathJottaCli().jottaclipathandcommand()
        let argumentssync = ["rem", catalogfordelete]
        let process = ProcessCommand(command: command,
                                     arguments: argumentssync,
                                     handlers: handlers,
                                     syncmode: syncmode.description,
                                     input: nil)
        do {
            try process.executeProcess()
        } catch let e {
            let error = e
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }
}
