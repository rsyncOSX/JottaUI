//
//  NavigationJottaUILogfileView.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 25/11/2023.
//

import Foundation
import Observation
import SwiftUI

struct NavigationJottaUILogfileView: View {
    @State private var resetloggfile = false
    @State private var logfilerecords: [LogfileRecords]?

    var body: some View {
        VStack {
            Table(logfilerecords ?? []) {
                TableColumn("Logfile") { data in
                    Text(data.logrecordline)
                }
            }
            .onChange(of: resetloggfile) {
                afterareload()
            }
        }
        .padding()
        .onAppear {
            Task {
                logfilerecords = await ActorCreateOutputforview().createoutputlogdata()
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    reset()
                } label: {
                    Image(systemName: "clear")
                }
                .help("Reset logfile")
                .buttonStyle(RefinedGlassButtonStyle())
            }
        }
    }

    func reset() {
        resetloggfile = true

        Task {
            await ActorJottaUILogToFile(true)
            logfilerecords = await ActorCreateOutputforview().createoutputlogdata()
        }
    }

    func afterareload() {
        resetloggfile = false
    }
}
