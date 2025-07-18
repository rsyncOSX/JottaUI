//
//  Export.swift
//  JottaUI
//
//  Created by Thomas Evensen on 18/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var focusexport: Bool

    @State var exportcatalog: String = Homepath().userHomeDirectoryPath ?? ""
    @State var filenameexport: String = "export"

    @State private var isShowingDialog: Bool = false
    @State private var showimportdialog: Bool = false

    var body: some View {
        VStack {
            HStack {
                Button("Export") {
                    executeexport()
                }
                .buttonStyle(ColorfulButtonStyle())

                Button("Dismiss") {
                    focusexport = false
                    dismiss()
                }
                .buttonStyle(ColorfulButtonStyle())
            }
        }
        .padding()
        .onAppear {
            if FileManager.default.locationExists(at: exportcatalog + "/" + "tmp", kind: .folder) {
                exportcatalog += "/" + "tmp" + "/"
            } else {
                exportcatalog += "/"
            }
        }
    }

    func executeexport() {
        let arguments = ["status", "--json"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        // Start progressview
        let process = ProcessCommand(command: command,
                                     arguments: arguments,
                                     processtermination: processterminationexport)
        process.executeProcess()
    }

    func processterminationexport(_ stringoutput: [String]?) {
        var path = ""
        if exportcatalog.hasSuffix("/") == true {
            path = exportcatalog + filenameexport + ".json"
        } else {
            path = exportcatalog + "/" + filenameexport + ".json"
        }
        guard exportcatalog.isEmpty == false, filenameexport.isEmpty == false else {
            focusexport = false
            return
        }

        if let stringoutput {
            let writepathandname = URL(fileURLWithPath: path)
            let data = Data(stringoutput.joined(separator: "\n").utf8)
            do {
                try data.write(to: writepathandname)
            } catch {
                focusexport = false
                dismiss()
            }
        }

        focusexport = false
        dismiss()
    }
}
