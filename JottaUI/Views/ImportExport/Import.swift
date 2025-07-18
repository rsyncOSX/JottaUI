//
//  Import.swift
//  RsyncUI
//
//  Created by Thomas Evensen on 21/07/2024.
//
// swiftlint:disable line_length

import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var focusimport: Bool
    @Binding var importfile: String

    @State private var isShowingDialog: Bool = false
    @State private var showimportdialog: Bool = false

    var body: some View {
        VStack {
            HStack {
                Button("Select a file for import") {
                    showimportdialog = true
                }
                .buttonStyle(ColorfulButtonStyle())
                .fileImporter(isPresented: $showimportdialog,
                              allowedContentTypes: [uutype],
                              onCompletion: { result in
                                  switch result {
                                  case let .success(url):
                                      importfile = url.relativePath
                                      guard importfile.isEmpty == false else { return }
                                      focusimport = false
                                      dismiss()
                                  case let .failure(error):
                                      SharedReference.shared.errorobject?.alert(error: error)
                                  }
                              })

                Button("Dismiss") {
                    focusimport = false
                    dismiss()
                }
                .buttonStyle(ColorfulButtonStyle())
            }
        }
        .padding()
    }

    var uutype: UTType {
        .item
    }
}

// swiftlint:enable line_length
