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
    
    @State private var tabledata: [Backuproot]?
    @State private var showtable: Bool = false

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
            .navigationDestination(isPresented: $showtable) {
                if let tabledata  {
                    OutputJottaDumpView(tabledate: tabledata)
                }
            }
            .onChange(of: tabledata?.count) {
                showtable = true
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
        tabledata = jsondata.setJSONstring(stringoutput)
        statusdumppath.append(StatusDump(task:.statusdumpview ))
    }
}
