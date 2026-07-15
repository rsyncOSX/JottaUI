//
//  OpencatalogView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct OpencatalogView: View {
    @Binding var selecteditem: String
    @State private var isImporting: Bool = false
    let catalogs: Bool

    var body: some View {
        Button(action: {
            isImporting = true
        }, label: {
            if catalogs {
                Image(systemName: "folder.fill")
                    .foregroundColor(Color(.blue))
            } else {
                Image(systemName: "text.document.fill")
                    .foregroundColor(Color(.blue))
            }
        })
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: [uutype],
                      onCompletion: { result in
                          switch result {
                          case let .success(url):
                              selecteditem = url.relativePath
                          case let .failure(error):
                              SharedReference.shared.errorobject?.alert(error: error)
                          }
                      })
        .buttonStyle(RefinedGlassButtonStyle())
    }

    var uutype: UTType {
        if catalogs {
            .directory
        } else {
            .item
        }
    }
}
