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

    @State private var scan: Bool = false
    
    @State private var focusimport: Bool = false
    @State private var importajsonfile: Bool = false
    @State private var importfile: String = ""

    var body: some View {
        NavigationStack(path: $statuspath) {
            ZStack {
                HStack {
                    Button {
                        executejsonstatus()
                    } label: {
                        Text("Status")
                    }
                    .buttonStyle(ColorfulButtonStyle())

                    Button {
                        executescan()
                    } label: {
                        Text("Scan")
                    }
                    .buttonStyle(ColorfulButtonStyle())
                }

                if showprogressview {
                    ProgressView()
                }
                
                if scan {
                    MessageView(mytext: "Scan is completed", size: .title3)
                        .padding()
                        .onAppear {
                            Task {
                                try await Task.sleep(seconds: 0.5)
                                scan = false
                            }
                        }
                }
            }
            .padding()
            .navigationTitle("Jotta status (JSON)")
            .navigationDestination(for: Status.self) { which in
                makeView(view: which.task)
            }
            .toolbar {
               
                ToolbarItem {
                    Button {
                        webview()
                    } label: {
                        Image(systemName: "network")
                    }
                    .help("Jottacloud Web")
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
            .sheet(isPresented: $importajsonfile) {
                ImportView(focusimport: $focusimport, importfile: $importfile)
            }
            .onChange(of: focusimport) {
                importajsonfile = focusimport
            }
            .onChange(of: importfile) {
                readimportfile(file: importfile)
            }
            .focusedSceneValue(\.importtasks, $focusimport)
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
    func webview() {
        let arguments = ["web"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        let process = ProcessCommand(command: command,
                                     arguments: arguments)
        process.executeProcess()
    }

    func abort() {
        InterruptProcess()
    }
    
    func executescan() {
        let arguments = ["scan"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processtermination)
        process.executeProcess()
    }

    func executejsonstatus() {
        let arguments = ["status", "--json"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processterminationjson)
        process.executeProcess()
    }

    func processterminationjson(_ stringoutput: [String]?) {
        showprogressview = false

        jsondata.setJSONstring(stringoutput)
        jsondata.debugJSONdata()
        statuspath.append(Status(task: .completedview))
    }

    func processtermination(_: [String]?) {
        showprogressview = false
        Task {
            try await Task.sleep(for: .seconds(1))
            executejsonstatus()
        }
    }
    
    func readimportfile(file: String) {
        var data: Data?
        let url = URL(fileURLWithPath: file, isDirectory: false)
        do {
            data = try Data(contentsOf: url)
            if let data {
                jsondata.setJSONData(data)
                jsondata.debugJSONdata()
                statuspath.append(Status(task: .completedview))
            }
        } catch {
            return
        }
    }
}
