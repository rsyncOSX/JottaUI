//
//  SidebarMainView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 12/12/2023.
//

import OSLog
import SwiftUI

enum Sidebaritems: String, Identifiable, CaseIterable {
    case status, add_catalogs_backup, Jotta_cli_help, logfile
    var id: String { rawValue }
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

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Only show profile picker if there are other profiles
            // Id default only, do not show profile picker

            Divider()

            List(Sidebaritems.allCases, selection: $selectedview) { item in
                NavigationLink(value: item) {
                    SidebarRow(sidebaritem: item)
                }
            }
            .listStyle(.sidebar)
            .disabled(statuspath.isEmpty == false || completedjottastatusview == false)

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
            NavigationJottaCliLogfileView()
        case .status:
            JottaStatusView(statuspath: $statuspath, completedjottastatusview: $completedjottastatusview)
        case .add_catalogs_backup:
            AddCatalogsForBackup()
        case .Jotta_cli_help:
            HelpView()
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
        case .add_catalogs_backup:
            "folder.fill"
        case .Jotta_cli_help:
            "questionmark"
        }
    }
}
