//
//  JottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 21/11/2023.
//

import SwiftUI

struct JottaStatusOutputView: View {
    @Binding var completedjottastatustextview: Bool

    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()

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
}

extension JottaStatusOutputView {
    
    func scan() {
        let arguments = ["status"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        // Start progressview
        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processtermination)
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

    func processtermination(_ stringoutput: [String]?) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputJottaCliforview().createaoutputforview(stringoutput)
            completedjottastatustextview = true
        }
    }
}
