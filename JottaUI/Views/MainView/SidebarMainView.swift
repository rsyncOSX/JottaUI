//
//  SidebarMainView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 12/12/2023.
//

import OSLog
import SwiftUI

enum Sidebaritems: String, Identifiable, CaseIterable {
    case status, status_text, add_catalogs_backup, logfile
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
    @State var statuspath: [Status] = []

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
            .disabled(statuspath.isEmpty == false)

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
        case .status_text:
            JottaStatusOutputView()
        case .status:
            JottaStatusView(statuspath: $statuspath)
        case .add_catalogs_backup:
            AddCatalogsForBackup()
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
        case .status_text:
            "arrowshape.turn.up.backward"
        case .status:
            "arrowshape.turn.up.backward.fill"
        case .add_catalogs_backup:
            "folder.fill"
        }
    }
}
