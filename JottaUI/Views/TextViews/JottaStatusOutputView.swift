//
//  JottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 21/11/2023.
//

import SwiftUI

struct JottaStatusOutputView: View {
    @State private var showprogressview = false
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var completed: Bool = false

    var body: some View {
        NavigationStack {
            HStack {
                if showprogressview {
                    ProgressView()
                } else {
                    Button {
                        let arguments = ["status"]
                        let command = FullpathJottaCli().jottaclipathandcommand()

                        // Start progressview
                        showprogressview = true
                        let process = ProcessCommand(command: command,
                                                     arguments: arguments,
                                                     processtermination: processtermination)
                        process.executeProcess()
                    } label: {
                        Text("Status")
                    }
                    .buttonStyle(ColorfulButtonStyle())
                }
            }
            .padding()
            .navigationTitle("Jotta status (Jotta-client output)")
            .navigationDestination(isPresented: $completed) {
                OutputJottaStatusOutputView(output: jottaclioutput.output ?? [])
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
    func abort() {
        InterruptProcess()
    }

    func processtermination(_ stringoutput: [String]?) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputJottaCliforview().createaoutputforview(stringoutput)
            completed = true
        }
    }
}
