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
        HStack {
            catalogforbackup

            OpencatalogView(selecteditem: $catalogsforbackup.catalogsforbackup, catalogs: true)

            Button {
                let catalogsforbackup = catalogsforbackup.catalogsforbackup
                let arguments = ["add", catalogsforbackup]
                let command = FullpathJottaCli().jottaclipathandcommand()
                // Start progressview
                let process = ProcessCommand(command: command,
                                                          arguments: arguments,
                                                          processtermination: processtermination)
                process.executeProcess()
            } label: {
                Text("Add")
            }
            .buttonStyle(ColorfulButtonStyle())
            .disabled(catalogsforbackup.verifycatalogsforbackup(catalogsforbackup.catalogsforbackup) == false)
        }
        .confirmationDialog(
            "Catalog for backup added",
            isPresented: $catalogadded
        ) {
            Button("Close", role: .cancel) {
                catalogsforbackup.catalogsforbackup = ""
                catalogadded = false
            }
        }
    }

    var catalogforbackup: some View {
        EditValueErrorScheme(400, NSLocalizedString("Catalog for backup", comment: ""),
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
