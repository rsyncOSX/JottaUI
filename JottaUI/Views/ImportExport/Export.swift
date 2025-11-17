//
//  Export.swift
//  JottaUI
//
//  Created by Thomas Evensen on 18/07/2025.
//

import ProcessCommand
import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var focusexport: Bool

    @State var exportcatalog: String = Homepath().userHomeDirectoryPath ?? ""
    @State private var path: String = ""

    @State var filenameexport: String = "export"

    @State private var isShowingDialog: Bool = false
    @State private var showimportdialog: Bool = false

    var body: some View {
        VStack {
            HStack {
                if exportcatalog.hasSuffix("/") {
                    Text(exportcatalog)
                        .foregroundColor(.secondary)
                } else {
                    Text(exportcatalog + "/")
                        .foregroundColor(.secondary)
                }

                setfilename

                Text(".json")
                    .foregroundColor(.secondary)

                OpencatalogView(selecteditem: $exportcatalog, catalogs: true)

                Button("Export") {
                    if exportcatalog.hasSuffix("/") == true {
                        path = exportcatalog + filenameexport + ".json"
                    } else {
                        path = exportcatalog + "/" + filenameexport + ".json"
                    }

                    guard exportcatalog.isEmpty == false, filenameexport.isEmpty == false else {
                        focusexport = false
                        return
                    }

                    executeexport()

                    focusexport = false
                }
                .help("Export tasks")
                .buttonStyle(RefinedGlassButtonStyle())

                Spacer()

                Button("Close", role: .close) {
                    focusexport = false
                    dismiss()
                }
                .buttonStyle(RefinedGlassButtonStyle())
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
        .frame(width: 600)
    }

    var setfilename: some View {
        EditValueScheme(150, NSLocalizedString("Filename export", comment: ""),
                        $filenameexport)
            .textContentType(.none)
    }

    func executeexport() {
        let handlers = CreateCommandHandlers().createcommandhandlers(
            processtermination: processtermination)
        let arguments = ["status", "--json"]
        let command = FullpathJottaCli().jottaclipathandcommand()
        // Start progressview
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

    func processtermination(_ stringoutput: [String]?, _: Bool) {
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
