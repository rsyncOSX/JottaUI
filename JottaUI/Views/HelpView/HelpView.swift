//
//  HelpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 22/07/2025.
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

struct HelpView: View {
    @State private var showhelp: Bool = false
    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var selectedhelpcommand: TypeofCommands?

    var body: some View {
        NavigationStack {
            HStack {
                if showprogressview {
                    ProgressView()
                } else {
                    pickerselecttypeofhelptask
                        .onChange(of: selectedhelpcommand) {
                            help()
                        }
                        .frame(width: 300)
                }
            }
            .padding()
            .navigationTitle("Help view")
            .navigationDestination(isPresented: $showhelp) {
                OutputJottaStatusOutputView(output: jottaclioutput.output ?? [])
            }
        }
    }

    var pickerselecttypeofhelptask: some View {
        Picker(NSLocalizedString("Command for help", comment: "") + ":",
               selection: $selectedhelpcommand)
        {
            Text("Select")
                .tag(nil as TypeofCommands?)
            ForEach(TypeofCommands.allCases) { Text($0.description)
                .tag($0)
            }
        }
        .pickerStyle(DefaultPickerStyle())
    }
}

extension HelpView {
    func help() {
        if let selectedhelpcommand {
            let arguments = [selectedhelpcommand.rawValue, "--help"]
            let command = FullpathJottaCli().jottaclipathandcommand()

            // Start progressview
            showprogressview = true
            let process = ProcessCommandAsyncSequence(command: command,
                                                      arguments: arguments,
                                                      processtermination: processterminationhelp)
            process.executeProcess()
        }
    }

    func processterminationhelp(_ stringoutput: [String]?) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputJottaCliforview().createaoutputforview(stringoutput)
            showhelp = true
        }
    }
}
