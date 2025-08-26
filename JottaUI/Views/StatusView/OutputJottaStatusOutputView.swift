//
//  OutputJottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 20/11/2023.
//

import SwiftUI

struct OutputJottaStatusOutputView: View {
    var output: [JottaCliOutputData]

    var body: some View {
        Table(output) {
            TableColumn("Output from Jotta-cli" + ": \(output.count) rows") { data in
                
                if data.record.contains("Up to date") {
                    Text(data.record)
                        .foregroundColor(Color.green)
                } else if data.record.contains("Transferring") {
                    Text(data.record)
                        .foregroundColor(Color.red)
                } else {
                    Text(data.record)
                }
            }
        }
        .padding()
    }
}
