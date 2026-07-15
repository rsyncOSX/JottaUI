//
//  SidebarMainView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 12/12/2023.
//

import SwiftUI

enum Sidebaritems: String, Identifiable, CaseIterable, Hashable {
    case status
    case catalogs
    case sync
    case dump
    case jottaCliHelp
    case logfile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .status:
            "Status"
        case .catalogs:
            "Catalogs"
        case .sync:
            "Sync"
        case .dump:
            "Dump"
        case .jottaCliHelp:
            "CLI Help"
        case .logfile:
            "Logs"
        }
    }

    var subtitle: String {
        switch self {
        case .status:
            "Scan, inspect and open Jottacloud"
        case .catalogs:
            "Manage folders sent to backup"
        case .sync:
            "Control the sync service"
        case .dump:
            "Inspect remote backup metadata"
        case .jottaCliHelp:
            "Browse jotta-cli command help"
        case .logfile:
            "Review app and CLI output"
        }
    }

    var symbol: String {
        switch self {
        case .status:
            "waveform.path.ecg.rectangle"
        case .catalogs:
            "folder.badge.gearshape"
        case .sync:
            "arrow.trianglehead.2.clockwise.rotate.90.circle"
        case .dump:
            "tray.and.arrow.down"
        case .jottaCliHelp:
            "terminal"
        case .logfile:
            "doc.text.magnifyingglass"
        }
    }
}

struct SidebarMainView: View {
    @Bindable var errorhandling: AlertError

    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var selectedview: Sidebaritems? = .status
    @State private var statuspath: [Status] = []
    @State private var completedjottastatusview = true
    @State private var showdumptabletable = false
    @State private var updateactionlogview = false
    @State private var syncisenabled = false

    private var currentSelection: Sidebaritems {
        selectedview ?? .status
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } detail: {
            ModernDetailScaffold(selection: currentSelection, isBusy: navigationIsLocked) {
                selectView(currentSelection)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: selectedview) {
            resetChildNavigation()
        }
        .alert("JottaUI", isPresented: errorhandling.isPresentingAlert) {
            Button("OK") {
                errorhandling.clearError()
            }
        } message: {
            if let error = errorhandling.activeError {
                Text(error.localizedDescription)
            } else {
                Text("No error")
            }
        }
    }

    private var sidebar: some View {
        VStack(spacing: 0) {
            SidebarHeader(version: SharedReference.shared.jottacliversion ?? "jotta-cli")

            List(selection: $selectedview) {
                Section {
                    ForEach(primaryItems) { item in
                        NavigationLink(value: item) {
                            ModernSidebarRow(item: item)
                        }
                            .tag(item as Sidebaritems?)
                    }
                }

                Section("Tools") {
                    ForEach(toolItems) { item in
                        NavigationLink(value: item) {
                            ModernSidebarRow(item: item)
                        }
                            .tag(item as Sidebaritems?)
                    }
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)

            SidebarFooter(isLocked: navigationIsLocked)
        }
        .background(.thinMaterial)
    }

    private var primaryItems: [Sidebaritems] {
        Sidebaritems.allCases.filter { item in
            switch item {
            case .status, .catalogs:
                true
            case .sync:
                syncisenabled
            case .dump, .jottaCliHelp, .logfile:
                false
            }
        }
    }

    private var toolItems: [Sidebaritems] {
        Sidebaritems.allCases.filter { item in
            switch item {
            case .dump, .jottaCliHelp, .logfile:
                true
            case .status, .catalogs:
                false
            case .sync:
                !primaryItems.contains(.sync)
            }
        }
    }

    private var navigationIsLocked: Bool {
        !completedjottastatusview || updateactionlogview
    }

    private func resetChildNavigation() {
        statuspath.removeAll()
        showdumptabletable = false
    }

    @MainActor @ViewBuilder
    private func selectView(_ view: Sidebaritems) -> some View {
        switch view {
        case .logfile:
            NavigationJottaCliLogfileView(updateactionlogview: $updateactionlogview)
        case .status:
            JottaStatusView(statuspath: $statuspath,
                            completedjottastatusview: $completedjottastatusview,
                            syncisenabled: $syncisenabled)
        case .catalogs:
            AddCatalogsView()
        case .jottaCliHelp:
            HelpView()
        case .dump:
            JottaDumpView(showdumptabletable: $showdumptabletable)
        case .sync:
            SyncView()
        }
    }
}

private struct SidebarHeader: View {
    let version: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: "icloud.and.arrow.up")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(.blue, in: .rect(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text("JottaUI")
                        .font(.headline)
                    Text("Mac Silicon command center")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 8) {
                StatusPill(title: "CLI", value: version)
                StatusPill(title: "Build", value: "arm64")
            }
        }
        .padding(18)
    }
}

private struct StatusPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.medium))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: .rect(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

private struct ModernSidebarRow: View {
    let item: Sidebaritems

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.callout.weight(.medium))
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        } icon: {
            Image(systemName: item.symbol)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
                .frame(width: 24)
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .combine)
    }
}

private struct SidebarFooter: View {
    let isLocked: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isLocked ? "lock.fill" : "checkmark.seal.fill")
                .foregroundStyle(isLocked ? .orange : .green)

            Text(isLocked ? "Working..." : "Ready")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.bar)
    }
}

private struct ModernDetailScaffold<Content: View>: View {
    let selection: Sidebaritems
    let isBusy: Bool
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HeaderBand(selection: selection, isBusy: isBusy)

            Divider()

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(nsColor: .windowBackgroundColor))
        }
    }
}

private struct HeaderBand: View {
    let selection: Sidebaritems
    let isBusy: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: selection.symbol)
                .font(.title.weight(.semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
                .frame(width: 52, height: 52)
                .background(.regularMaterial, in: .rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(selection.title)
                    .font(.title2.weight(.semibold))
                Text(selection.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Label(isBusy ? "Task active" : "Ready", systemImage: isBusy ? "clock.arrow.circlepath" : "checkmark.circle")
                .font(.callout.weight(.medium))
                .foregroundStyle(isBusy ? .orange : .green)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: .rect(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.quaternary, lineWidth: 1)
                }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
