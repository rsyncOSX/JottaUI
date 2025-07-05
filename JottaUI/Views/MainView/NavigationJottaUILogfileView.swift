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
                    Text(data.line)
                }
            }
            .onChange(of: resetloggfile) {
                afterareload()
            }
        }
        .padding()
        .onAppear {
            Task {
                logfilerecords = await ActorGenerateJottaUILogfileforview().generatedata()
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
            }
        }
    }

    func reset() {
        resetloggfile = true

        Task {
            await ActorJottaUILogToFile(true)
            logfilerecords = await ActorGenerateJottaUILogfileforview().generatedata()
        }
    }

    func afterareload() {
        resetloggfile = false
    }
}
