//
//  OutputJottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import SwiftUI

struct OutputJottaDumpView: View {
    
    // Filterstring
    @Binding var filterstring: String
    
    let tabledate: [Files]

    var body: some View {
        VStack(alignment: .center) {
            Table(tabledate) {
                TableColumn("BackupRoot", value: \.backuproot)
                    // TableColumn("DeviceID", value: \.DeviceID)
                    .width(min: 80, max: 400)

                TableColumn("Folder", value: \.folder)
                    .width(min: 80, max: 300)
                
                TableColumn("Name", value: \.name)
                    .width(min: 80, max: 200)
                
                TableColumn("Size") { data in
                    Text(formatted_number(data.size))
                }
                .width(min: 40, max: 80)
                .alignment(.trailing)
                
                TableColumn("MD5", value: \.md5)
                    .width(min: 80, max: 400)
            }
        }
        .padding()
        .searchable(text: $filterstring)
    }
    
    func formatted_number(_ number: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
    }
}

