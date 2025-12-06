//
//  JottaStatusView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import Foundation
import OSLog
import ProcessCommand
import SwiftUI

enum DestinationView: String, Identifiable {
    case statusjsonview, logfileview, statustextview
    var id: String { rawValue }
}

struct Status: Hashable, Identifiable {
    let id = UUID()
    var task: DestinationView
}

struct JottaStatusView: View {
    @Binding var statuspath: [Status]
    @Binding var completedjottastatusview: Bool
    @Binding var syncisenabled: Bool

    @State private var jsondata = ObservableJSONStatus()
    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var completed: Bool = false

    @State private var jsonstatus: Bool = true

    @State private var importorexport: Bool = false
    @State private var focusexport: Bool = false
    @State private var focusimport: Bool = false
    @State private var importajsonfile: Bool = false
    @State private var filenameimport: String = ""

    @State private var errordiscovered: Bool = false

    var body: some View {
        NavigationStack(path: $statuspath) {
            HStack {
                if showprogressview {
                    ProgressView()

                } else {
                    HStack {
                        
                        Button {
                            completedjottastatusview = false

                            if jsonstatus {
                                executescan()
                            } else {
                                executestatus()
                            }

                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Go")
                            }
                        }
                        .buttonStyle(RefinedGlassButtonStyle())

                        Toggle("JSON", isOn: $jsonstatus)
                            .toggleStyle(.switch)
                    }
                    .frame(width: 200)
                }
            }
            .padding()
            .navigationTitle("Jotta status")
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
                    .buttonStyle(RefinedGlassButtonStyle())
                }
                ToolbarItem {
                    Spacer()
                }

                ToolbarItem {
                    Button {
                        statuspath.append(Status(task: .logfileview))
                    } label: {
                        Image(systemName: "doc.plaintext")
                    }
                    .help("View logfile")
                    .buttonStyle(RefinedGlassButtonStyle())
                }
            }
            .sheet(isPresented: $importorexport) {
                if focusexport {
                    ExportView(focusexport: $focusexport)
                } else {
                    ImportView(focusimport: $focusimport, importfile: $filenameimport)
                }
            }
            .onChange(of: focusexport) {
                importorexport = focusexport
            }
            .onChange(of: focusimport) {
                importorexport = focusimport
            }
            .onChange(of: filenameimport) {
                readimportfile(file: filenameimport)
            }
            .focusedSceneValue(\.importtasks, $focusimport)
            .focusedSceneValue(\.exporttasks, $focusexport)
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
        case .statusjsonview:
            JottaStatusJsonOutputView(jsondata: $jsondata)
                .onDisappear {
                    jsondata.backups.removeAll()

                    if jsonstatus {
                        jsonstatus = false
                    }
                }

        case .logfileview:
            NavigationJottaUILogfileView()

        case .statustextview:
            JottaStatusOutputView(output: jottaclioutput.output ?? [])
        }
    }
}

extension JottaStatusView {
    // For text view
    func executestatus() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processtermination)
        let arguments = ["status"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     handlers: handlers,
                                     syncmode: nil,
                                     input: nil)
        do {
            try process.executeProcess()
        } catch let e {
            let error = e
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }

    func webview() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: { _, _ in })
        let arguments = ["web"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     handlers: handlers)
        do {
            try process.executeProcess()
        } catch let e {
            let error = e
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }

    func abort() {
        InterruptProcess()
    }

    // Execute a scan before JSON view
    func executescan() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processtermination)
        let arguments = ["scan"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     handlers: handlers,
                                     syncmode: nil,
                                     input: nil)
        do {
            try process.executeProcess()
        } catch let e {
            let error = e
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }

    func processterminationjson(_ stringoutput: [String]?, _: Bool) {
        showprogressview = false
        completedjottastatusview = true
        jsondata.setJSONstring(stringoutput)
        jsondata.debugJSONdata()
        statuspath.append(Status(task: .statusjsonview))
    }

    func processtermination(_ stringoutput: [String]?, _: Bool) {
        if jsonstatus {
            let handlers = CreateCommandHandlers().createcommandhandlers(
                processtermination: processterminationjson)
            let arguments = ["status", "--json"]
            let command = FullpathJottaCli().jottaclipathandcommand()
            let process = ProcessCommand(command: command,
                                         arguments: arguments,
                                         handlers: handlers,
                                         syncmode: nil,
                                         input: nil)
            do {
                try process.executeProcess()
            } catch let e {
                let error = e
                SharedReference.shared.errorobject?.alert(error: error)
            }

        } else {
            showprogressview = false
            Task {
                jottaclioutput.output = await ActorCreateOutputforview().createaoutput(stringoutput)
                syncisenabled = await ActorCreateOutputforview().syncisenabled(stringoutput ?? [])
                completedjottastatusview = true
                statuspath.append(Status(task: .statustextview))
            }
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
                statuspath.append(Status(task: .statusjsonview))
            }
        } catch {
            return
        }
    }
}
