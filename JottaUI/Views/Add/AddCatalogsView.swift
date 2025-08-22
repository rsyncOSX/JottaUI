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

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase.replacingOccurrences(of: "_", with: " ") }
}

struct AddCatalogsView: View {
    @State private var catalogsforbackup = ObservableCatalogsforbackup()
    @State private var catalogadded: Bool = false
    @State private var jottatask = JottaTask.backup
    
    @State private var errordiscovered: Bool = false

    var body: some View {
        HStack {
            catalogforbackup

            OpencatalogView(selecteditem: $catalogsforbackup.catalogsforbackup, catalogs: true)

                Picker(NSLocalizedString("Task", comment: ""),
                       selection: $jottatask)
                {
                    ForEach(JottaTask.allCases) { Text($0.description)
                        .tag($0)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .frame(width: 150)

                Button {
                    let catalogsforbackup = catalogsforbackup.catalogsforbackup
                    let argumentsbackup = ["add", catalogsforbackup]
                    let argumentssync = ["sync", "setup", "--root", catalogsforbackup]
                    let command = FullpathJottaCli().jottaclipathandcommand()
                    if jottatask == .backup {
                        let process = ProcessCommand(command: command,
                                                     arguments: argumentsbackup,
                                                     processtermination: processtermination)
                        // Start progressview
                        process.executeProcess()
                    } else {
                        let process = ProcessCommand(command: command,
                                                     arguments: argumentssync,
                                                     processtermination: processtermination)
                        // Start progressview
                        process.executeProcess()
                    }

                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
                .disabled(catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) == false)
            
        }
        .confirmationDialog(
            confirmation,
            isPresented: $catalogadded
        ) {
            Button("Close", role: .cancel) {
                catalogsforbackup.catalogsforbackup = ""
                catalogadded = false
            }
            .buttonStyle(ColorfulButtonStyle())
        }
    }

    var catalogforbackup: some View {
        EditValueErrorScheme(300, NSLocalizedString(defaultstring, comment: ""),
                             $catalogsforbackup.catalogsforbackup,
                             catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup))
            .foregroundColor(catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) ? Color.white : Color.red)
            .onChange(of: catalogsforbackup.catalogsforbackup) {
                Task {
                    guard catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) else {
                        return
                    }
                }
            }
    }

    var confirmation: String {
        if jottatask == .backup {
            "Catalog for BACKUP added"
        } else {
            "Catalog for SYNC added"
        }
    }

    var defaultstring: String {
        if jottatask == .backup {
            "Catalog for BACKUP"
        } else {
            "Catalog for SYNC"
        }
    }

    func processtermination(_: [String]?,  _ errordiscovered: Bool) {
        catalogadded = !errordiscovered
    }
}
