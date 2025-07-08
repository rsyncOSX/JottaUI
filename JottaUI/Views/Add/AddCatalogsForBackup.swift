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

    var body: some View {
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
}
