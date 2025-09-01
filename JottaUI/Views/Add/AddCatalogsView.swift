//
//  AddCatalogsView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import OSLog
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
    @State private var selectedcatalog: Paths.ID?

    var body: some View {
        VStack {
            
            HStack {
                catalogforbackup

                OpencatalogView(selecteditem: $observablecatalogsforbackup.catalogsforbackup, catalogs: true)

                VStack {
                    Picker(NSLocalizedString("Task", comment: ""),
                           selection: $jottatask)
                    {
                        ForEach(JottaTask.allCases) { Text($0.description)
                            .tag($0)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .frame(width: 150)

                    if jottatask == .sync {
                        Picker(NSLocalizedString("Mode", comment: ""),
                               selection: $syncmode)
                        {
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
                        let argumentsbackup = ["add", catalogsforbackup]
                        let process = ProcessCommand(command: command,
                                                     arguments: argumentsbackup,
                                                     syncmode: nil,
                                                     input: nil,
                                                     processtermination: processtermination)
                        // Start progressview
                        process.executeProcess()
                    } else if jottatask == .sync {
                        let argumentssync = ["sync", "setup", "--root", catalogsforbackup]
                        let process = ProcessCommand(command: command,
                                                     arguments: argumentssync,
                                                     syncmode: syncmode.description,
                                                     input: nil,
                                                     processtermination: processtermination)
                        // Start progressview
                        process.executeProcess()
                    }

                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
                .disabled(observablecatalogsforbackup.verifycatalogsforbackup(observablecatalogsforbackup.catalogsforbackup) == false)
                .buttonStyle(.borderedProminent)
            }
            
            VStack {
                
                Button {
                    observablecatalogsforbackup.paths = nil
                    observablecatalogsforbackup.excutestatusjson()

                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
                
                if let paths = observablecatalogsforbackup.paths {
                    Table(paths, selection: $selectedcatalog) {
                        TableColumn("Path") { path in
                            Text(path.path ?? "")
                        }
                    }
                    .frame(width: 300, height: 300, alignment: .center)
                    .padding()
                }
            }
        }
        .confirmationDialog(
            confirmation,
            isPresented: $catalogadded
        ) {
            Button("Close", role: .cancel) {
                observablecatalogsforbackup.catalogsforbackup = ""
                catalogadded = false
            }
            .buttonStyle(ColorfulButtonStyle())
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
    }
}
