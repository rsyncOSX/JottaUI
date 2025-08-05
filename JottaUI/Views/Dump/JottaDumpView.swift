//
//  JottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation
import OSLog
import SwiftUI

struct JottaDumpView: View {
    
    @Binding var showdumptabletable: Bool

    @State private var showprogressview = false
    @State private var completed: Bool = false
    @State private var tabledata: [Files]?
    
    @State private var filterstring: String = ""

    var body: some View {
        NavigationStack {
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
            .navigationDestination(isPresented: $showdumptabletable) {
                if let tabledata {
                    OutputJottaDumpView(filterstring: $filterstring, tabledate: tabledata)
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

extension JottaDumpView {
    // For text view
    func executedump() {
        let arguments = ["dump"]
        let command = FullpathJottaCli().jottaclipathandcommand()
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
        Task {
            if let stringoutput {
                async let data = ActorConvertDumpData().convertStringToData(stringoutput)
                tabledata = await ActorConvertDumpData().convertDataToBackup(data)
                showprogressview = false
                showdumptabletable = true
            }
        }
    }
}
