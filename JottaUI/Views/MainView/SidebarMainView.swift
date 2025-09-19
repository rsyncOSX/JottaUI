//
//  SidebarMainView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 12/12/2023.
//

import OSLog
import SwiftUI

enum Sidebaritems: String, Identifiable, CaseIterable {
    case status, catalogs, sync, dump, Jotta_cli_help, logfile
    var id: String { rawValue }
}

// The sidebar is context sensitive, it is computed everytime a new profile is loaded
struct MenuItem: Identifiable, Hashable {
    var menuitem: Sidebaritems
    let id = UUID()
}

struct SidebarMainView: View {
    @Bindable var errorhandling: AlertError
    // Toggle sidebar
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var selectedview: Sidebaritems = .status
    // Status JSON
    @State var statuspath: [Status] = []
    // Status text
    @State var completedjottastatusview: Bool = true
    // Show dumptable
    @State private var showdumptabletable: Bool = false
    // Set progressview when resetting, filter or reset data
    // Set as @Binding in NavigationJottaCliLogfileView to enable (or disable)
    // selecting another main meny when sort and filter logrecords in progress
    @State private var updateactionlogview: Bool = false
    // Sync is enabled
    @State private var syncisenabled: Bool = false

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
            Divider()
            
            List(menuitems, selection: $selectedview) { item in
                NavigationLink(value: item.menuitem) {
                    SidebarRow(sidebaritem: item.menuitem)
                }
                
                if item.menuitem == .Jotta_cli_help ||
                    item.menuitem == .dump ||
                    item.menuitem == .catalogs

                { Divider() }
            }
            .listStyle(.sidebar)
            .disabled(statuspath.isEmpty == false ||
                completedjottastatusview == false ||
                showdumptabletable == true ||
                updateactionlogview == true)

            MessageView(mytext: SharedReference.shared.jottacliversion ?? "", size: .caption2)

        } detail: {
            selectView(selectedview)
        }
        .alert(isPresented: errorhandling.presentalert, content: {
            if let error = errorhandling.activeError {
                Alert(localizedError: error)
            } else {
                Alert(title: Text("No error"))
            }
        })
    }

    @MainActor @ViewBuilder
    func selectView(_ view: Sidebaritems) -> some View {
        switch view {
        case .logfile:
            NavigationJottaCliLogfileView(updateactionlogview: $updateactionlogview)
        case .status:
            JottaStatusView(statuspath: $statuspath,
                            completedjottastatusview: $completedjottastatusview,
                            syncisenabled: $syncisenabled)
        case .catalogs:
            AddCatalogsView()
        case .Jotta_cli_help:
            HelpView()
        case .dump:
            JottaDumpView(showdumptabletable: $showdumptabletable)
        case .sync:
            SyncView()
        }
    }
    
    // The Sidebar meny is context sensitive. There are three Sidebar meny options
    // which are context sensitive:
    // - Snapshots
    // - Verify remote
    // - Restore
    var menuitems: [MenuItem] {
        Sidebaritems.allCases.compactMap { item in
            // Return nil if there is one or more snapshot tasks
            // Do not show the Snapshot sidebar meny
            if syncisenabled == false,
               item == .sync { return nil }
            
            return MenuItem(menuitem: item)
        }
    }
}

struct SidebarRow: View {
    var sidebaritem: Sidebaritems

    var body: some View {
        Label(sidebaritem.rawValue.localizedCapitalized.replacingOccurrences(of: "_", with: " "),
              systemImage: systemimage(sidebaritem))
    }

    func systemimage(_ view: Sidebaritems) -> String {
        switch view {
        case .logfile:
            "doc.plaintext"
        case .status:
            "arrowshape.turn.up.backward.fill"
        case .catalogs:
            "folder.fill"
        case .Jotta_cli_help:
            "questionmark"
        case .dump:
            "arrowshape.down.circle.fill"
        case .sync:
            "arrow.trianglehead.2.clockwise.rotate.90.circle.fill"
        }
    }
}
