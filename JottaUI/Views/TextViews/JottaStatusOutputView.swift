//
//  JottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 21/11/2023.
//

import SwiftUI

enum TypeofCommands: String, CaseIterable, Identifiable, CustomStringConvertible {
    case add
    case archive
    case completion
    case config

    case download
    case dump
    case help
    case ignores

    case list
    case logfile
    case login
    case logout

    case ls
    case observe
    case pause
    case rem

    case resume
    case scan
    case share
    case status

    case sync
    case tail
    case trash
    case version

    case web
    case webhook

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase }
}

struct JottaStatusOutputView: View {
    @Binding var completedjottastatustextview: Bool

    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var selectedhelpcommand: TypeofCommands?

    var body: some View {
        NavigationStack {
            HStack {
                if showprogressview {
                    ProgressView()
                } else {
                    Button {
                        scan()
                    } label: {
                        Text("Status")
                    }
                    .buttonStyle(ColorfulButtonStyle())
                }
            }
            .padding()
            .navigationTitle("Jotta status (text)")
            .navigationDestination(isPresented: $completedjottastatustextview) {
                OutputJottaStatusOutputView(output: jottaclioutput.output ?? [])
            }
            .toolbar {
                ToolbarItem {
                    pickerselecttypeofhelptask
                        .onChange(of: selectedhelpcommand) {
                            help()
                        }
                }

                ToolbarItem {
                    Button {
                        webview()
                    } label: {
                        Image(systemName: "network")
                    }
                    .help("Jottacloud Web")
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

    var pickerselecttypeofhelptask: some View {
        Picker(NSLocalizedString("", comment: "") + ":",
               selection: $selectedhelpcommand)
        {
            Text("Help on command")
                .tag(nil as TypeofCommands?)
            ForEach(TypeofCommands.allCases) { Text($0.description)
                .tag($0)
            }
        }
        .pickerStyle(DefaultPickerStyle())
    }
}

extension JottaStatusOutputView {
    func help() {
        if let selectedhelpcommand {
            let arguments = [selectedhelpcommand.rawValue, "--help"]
            let command = FullpathJottaCli().jottaclipathandcommand()

            // Start progressview
            showprogressview = true
            let process = ProcessCommand(command: command,
                                         arguments: arguments,
                                         processtermination: processterminationhelp)
            process.executeProcess()
        }
    }

    func scan() {
        let arguments = ["status"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processterminationhelp)
        process.executeProcess()
    }

    func list() {
        let arguments = ["list"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processterminationhelp)
        process.executeProcess()
    }

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

    func processterminationhelp(_ stringoutput: [String]?) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputJottaCliforview().createaoutputforview(stringoutput)
            completedjottastatustextview = true
        }
    }
}
