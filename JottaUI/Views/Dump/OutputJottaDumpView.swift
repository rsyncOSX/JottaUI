//
//  OutputJottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import SwiftUI

struct OutputJottaDumpView: View {
    // Filterstring
    @State private var filterstring: String = ""
    @State private var selectedItemID: Files.ID?

    let tabledate: [Files]

    var body: some View {
        VStack(alignment: .center) {
            Table(tabledate, selection: $selectedItemID) {
                TableColumn("BackupRoot") { data in
                    cellWithHighlight(data: data) {
                        Text(data.backuproot)
                    }
                }
                .width(min: 80, max: 400)
                TableColumn("Folder") { data in
                    cellWithHighlight(data: data) {
                        Text(data.folder)
                    }
                }
                .width(min: 80, max: 400)
                TableColumn("Name") { data in
                    cellWithHighlight(data: data) {
                        Text(data.name)
                    }
                }
                .width(min: 80, max: 400)
                TableColumn("Size") { data in
                    cellWithHighlight(data: data) {
                        Text(formatted_number(data.size))
                    }
                }
                .width(min: 40, max: 80)
                .alignment(.trailing)
                TableColumn("MD5") { data in
                    cellWithHighlight(data: data) {
                        Text(data.md5)
                    }
                }
                .width(min: 80, max: 400)
            }
        }
        .padding()
        .searchable(text: $filterstring)
    }

    /*
     // Not Case sensitive
     @ViewBuilder
     func cellWithHighlight(data: Files, @ViewBuilder content: () -> some View) -> some View {
         let highlight = !filterstring.isEmpty &&
             (
                 data.backuproot.localizedCaseInsensitiveContains(filterstring) ||
                 data.folder.localizedCaseInsensitiveContains(filterstring) ||
                 data.name.localizedCaseInsensitiveContains(filterstring) ||
                 data.md5.localizedCaseInsensitiveContains(filterstring)
             )
         content()
             .padding(.vertical, 2)
             .background(highlight ? Color.yellow.opacity(0.3) : Color.clear)
             .cornerRadius(3)
     }
     */

    @ViewBuilder
    // Case sensitive
    func cellWithHighlight(data: Files, @ViewBuilder content: () -> some View) -> some View {
        let highlight = !filterstring.isEmpty &&
            (
                data.backuproot.contains(filterstring) ||
                    data.folder.contains(filterstring) ||
                    data.name.contains(filterstring) ||
                    data.md5.contains(filterstring)
            )
        content()
            .padding(.vertical, 2)
            .background(highlight ? Color.yellow.opacity(0.3) : Color.clear)
            .cornerRadius(3)
    }

    func formatted_number(_ number: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
    }
}
