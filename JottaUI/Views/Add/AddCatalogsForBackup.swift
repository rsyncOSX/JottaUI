//
//  AddCatalogsForBackup.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import OSLog
import SwiftUI

struct AddCatalogsForBackup: View {
    @State private var catalogsforbackup = ObservableCatalogsforbackup()
    @State private var catalogadded: Bool = false

    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        setpathforrestore

                        OpencatalogView(selecteditem: $catalogsforbackup.catalogsforbackup, catalogs: true)
                    }
                } header: {
                    Text("Catalog for backup")
                }
                .formStyle(.grouped)
            }

            if catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) {
                Form {
                    Button {
                        let catalogsforbackup = catalogsforbackup.catalogsforbackup
                        let arguments = ["add",catalogsforbackup]
                        let command = FullpathJottaCli().jottaclipathandcommand()
                        // Start progressview
                        let process = ProcessCommand(command: command,
                                                     arguments: arguments,
                                                     processtermination: processtermination)
                        process.executeProcess()
                    } label: {
                        Text("Add catalog")
                    }
                    .buttonStyle(ColorfulButtonStyle())
                }
            }
        }
        .confirmationDialog(
            "Catalog for backup added",
            isPresented: $catalogadded
        ) {
            Button("Dismiss", role: .cancel) {
                catalogadded = false
            }
        }
    }

    var setpathforrestore: some View {
        EditValueScheme(400, NSLocalizedString("Catalog for backup", comment: ""),
                        $catalogsforbackup.catalogsforbackup,
                        catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup))
            .foregroundColor(catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) ? Color.white : Color.red)
            .onChange(of: catalogsforbackup.catalogsforbackup) {
                Task {
                    guard catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) else {
                        return
                    }
                    if catalogsforbackup.catalogsforbackup.hasSuffix("/") == false {
                        catalogsforbackup.catalogsforbackup.append("/")
                    }
                }
            }
    }

    func processtermination(_: [String]?) {
        catalogadded = true
    }
}
