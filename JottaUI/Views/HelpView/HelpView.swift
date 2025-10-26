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
                JottaStatusOutputView(output: jottaclioutput.output ?? [])
            }
            
            HelpView.previews
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
    
    static var previews: some View {
            Group {
                VStack(spacing: 16) {
                    Button("Refined Glass") {}
                        .buttonStyle(RefinedGlassButtonStyle())

                    Button(action: {}) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send")
                        }
                    }
                    .buttonStyle(RefinedGlassButtonStyle())

                    Button("Small") {}
                        .buttonStyle(RefinedGlassButtonStyle(cornerRadius: 8, horizontalPadding: 10, verticalPadding: 6, font: .subheadline))

                    Button("Disabled") {}
                        .buttonStyle(RefinedGlassButtonStyle())
                        .disabled(true)
                }
                .padding()
                .previewDisplayName("Light")

                VStack(spacing: 16) {
                    Button("Refined Glass") {}
                        .buttonStyle(RefinedGlassButtonStyle())

                    Button("Small") {}
                        .buttonStyle(RefinedGlassButtonStyle(cornerRadius: 8, horizontalPadding: 10, verticalPadding: 6, font: .subheadline))

                    Button("Disabled") {}
                        .buttonStyle(RefinedGlassButtonStyle())
                        .disabled(true)
                }
                .padding()
                .background(Color.black)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
            }
            .previewLayout(.sizeThatFits)
        }
}

extension HelpView {
    func help() {
        if let selectedhelpcommand {
            let arguments = [selectedhelpcommand.rawValue, "--help"]
            let command = FullpathJottaCli().jottaclipathandcommand()

            // Start progressview
            showprogressview = true
            let process = ProcessCommand(command: command,
                                         arguments: arguments,
                                         syncmode: nil,
                                         input: nil,
                                         processtermination: processterminationhelp)
            process.executeProcess()
        }
    }

    func processterminationhelp(_ stringoutput: [String]?, _: Bool) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputforview().createaoutput(stringoutput)
            showhelp = true
        }
    }
}
