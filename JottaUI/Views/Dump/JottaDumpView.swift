//
//  JottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation
import OSLog
import ProcessCommand
import SwiftUI

struct JottaDumpView: View {
    @Binding var showdumptabletable: Bool

    @State private var showprogressview = false
    @State private var completed: Bool = false
    @State private var tabledata: [Files]?

    @State private var excludegitcatalogs: Bool = true
    // Not used yet
    @State private var errordiscovered: Bool = false

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
                            Image(systemName: "arrowshape.down.circle.fill")
                                .imageScale(.large)
                            // .foregroundColor(Color(.blue))
                        }
                        .buttonStyle(RefinedGlassButtonStyle())

                        Toggle("Excl ./git", isOn: $excludegitcatalogs)
                            .toggleStyle(.switch)
                            .onTapGesture {
                                withAnimation(Animation.easeInOut(duration: true ? 0.35 : 0)) {
                                    excludegitcatalogs.toggle()
                                }
                            }
                    }
                    .frame(width: 200)
                }
            }
            .padding()
            .navigationTitle("Jotta DUMP (JSON)")
            .navigationDestination(isPresented: $showdumptabletable) {
                if let tabledata {
                    OutputJottaDumpView(tabledate: tabledata)
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
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processtermination)
        let arguments = ["dump"]
        let command = FullpathJottaCli().jottaclipathandcommand()

        showprogressview = true
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     handlers: handlers,
                                     syncmode: nil,
                                     input: nil)
        do {
            try process.executeProcess()
        } catch let err {
            let error = err
            SharedReference.shared.errorobject?.alert(error: error)
        }
    }

    func abort() {
        InterruptProcess()
    }

    func processtermination(_ stringoutput: [String]?, _: Bool) {
        Task {
            if let stringoutput {
                async let data = ActorConvertDumpData().convertStringToData(stringoutput)
                tabledata = await ActorConvertDumpData().convertDataToBackup(data, excludegitcatalogs)
                showprogressview = false
                showdumptabletable = true
            }
        }
    }
}
