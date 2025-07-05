//
//  JottaStatusView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import Foundation
import OSLog
import SwiftUI

enum DestinationView: String, Identifiable {
    case completedview, logfileview
    var id: String { rawValue }
}

struct Status: Hashable, Identifiable {
    let id = UUID()
    var task: DestinationView
}

struct JottaStatusView: View {
    @Binding var statuspath: [Status]

    @State private var jsondata = ObservableJSONStatus()
    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var completed: Bool = false

    @State private var mockdata: Bool = false
    @State private var scan: Bool = false

    var body: some View {
        NavigationStack(path: $statuspath) {
            ZStack {
                if mockdata {
                    Button {
                        mockprocesstermination()
                    } label: {
                        Text("Mockdata Status")
                    }
                    .buttonStyle(ColorfulButtonStyle())

                } else {
                    HStack {
                        Button {
                            let arguments = ["status", "--json"]
                            let command = "/opt/homebrew/bin/jotta-cli"

                            // Start progressview
                            showprogressview = true
                            let process = ProcessCommand(command: command,
                                                         arguments: arguments,
                                                         processtermination: processterminationjson)
                            process.executeProcess()
                        } label: {
                            Text("Status")
                        }
                        .buttonStyle(ColorfulButtonStyle())

                        Button {
                            let arguments = ["scan"]
                            let command = "/opt/homebrew/bin/jotta-cli"

                            // Start progressview
                            showprogressview = true
                            let process = ProcessCommand(command: command,
                                                         arguments: arguments,
                                                         processtermination: processtermination)
                            process.executeProcess()
                        } label: {
                            Text("Scan")
                        }
                        .buttonStyle(ColorfulButtonStyle())
                    }
                }
            }
            .padding()
            .navigationTitle("Jotta status")
            .navigationDestination(for: Status.self) { which in
                makeView(view: which.task)
            }
            .toolbar {
                ToolbarItem {
                    ToggleView(text: "Mockdata", binding: $mockdata)
                }

                ToolbarItem {
                    Button {
                        statuspath.append(Status(task: .logfileview))
                    } label: {
                        Image(systemName: "doc.plaintext")
                    }
                    .help("View logfile")
                }
            }
            .sheet(isPresented: $scan) {
                Text("Scan is completed")
                    .font(.caption)
                    .padding()
                    .onAppear {
                        Task {
                            try await Task.sleep(seconds: 1)
                            scan = false
                        }
                    }
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
    func makeView(view: DestinationView) -> some View {
        switch view {
        case .completedview:
            OutputJottaStatusView(jsondata: $jsondata)
                .onDisappear {
                    jsondata.backups.removeAll()
                }

        case .logfileview:
            NavigationJottaUILogfileView()
        }
    }
}

extension JottaStatusView {
    func abort() {
        InterruptProcess()
    }

    func processterminationjson(_ stringoutput: [String]?) {
        showprogressview = false

        jsondata.setJSONstring(stringoutput)
        jsondata.debugJSONdata()
        statuspath.append(Status(task: .completedview))
    }

    func processtermination(_: [String]?) {
        showprogressview = false
        scan = true
    }

    func mockprocesstermination() {
        let data = Data(MockdataJson().json.utf8)
        jsondata.setJSONData(data)
        jsondata.debugJSONdata()
        statuspath.append(Status(task: .completedview))
    }
}
