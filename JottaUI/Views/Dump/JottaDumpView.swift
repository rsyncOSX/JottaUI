//
//  JottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//


import Foundation
import OSLog
import SwiftUI

enum DestinationDumpView: String, Identifiable {
    case statusdumpview
    var id: String { rawValue }
}

struct StatusDump: Hashable, Identifiable {
    let id = UUID()
    var task: DestinationDumpView
}

struct JottaDumpView: View {
    @Binding var statusdumppath: [StatusDump]

    @State private var jsondata = ObservableDUMPOutput()
    @State private var showprogressview = false
    @State private var completed: Bool = false

    var body: some View {
        NavigationStack(path: $statusdumppath) {
            HStack {
                if showprogressview {
                    
                    ProgressView()

                } else {
                    HStack {
                        Button {
                            
                            executedump()
                            
                        } label: {
                            Text("Dump")
                        }
                        .buttonStyle(ColorfulButtonStyle())

                    }
                    .frame(width: 200)
                }
            }
            .padding()
            .navigationTitle("Jotta DUMP (JSON)")
            .navigationDestination(for: StatusDump.self) { which in
                makeView(view: which.task)
            }
        }
    }

    var labelaborttask: some View {
        Label("", systemImage: "play.fill")
            .onAppear(perform: {
                abort()
            })
    }

    @MainActor @ViewBuilder
    func makeView(view: DestinationDumpView) -> some View {
        switch view {
        case .statusdumpview:
            OutputJottaDumpView(jsondata: $jsondata)
                .onDisappear {
                    jsondata.backups.removeAll()
                }
        }
    }
}

extension JottaDumpView {
    // For text view
    func executedump() {
        let arguments = ["dump"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommandAsyncSequence(command: command,
                                                  arguments: arguments,
                                                  processtermination: processtermination)
        process.executeProcess()
    }

    func abort() {
        InterruptProcess()
    }
    
    func processtermination(_ stringoutput: [String]?) {
        showprogressview = false
        jsondata.setJSONstring(stringoutput)
        jsondata.debugJSONdata()
        statusdumppath.append(StatusDump(task:.statusdumpview ))
    }
}
