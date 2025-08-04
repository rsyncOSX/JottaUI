//
//  OutputJottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//


import SwiftUI

struct OutputJottaDumpView: View {
    
    let tabledate: [Backuproot]

    var body: some View {
        VStack(alignment: .center) {
            
            Table(tabledate) {
                TableColumn("BackupRoot", value: \.backuproot)
                    // TableColumn("DeviceID", value: \.DeviceID)
                    .width(min: 120, max: 400)

                TableColumn("Folder", value: \.folder)
                    .width(min: 80, max: 200)
            }
            
        }
        .padding()
    }
}
