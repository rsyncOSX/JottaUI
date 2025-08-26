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
            TableColumn("Status Jotta-cli" + ": \(output.count) rows") { data in
                
                if data.record.contains("------") {
                    Text("")
                } else {
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
            
            TableColumn("Date") { data in
                
                if data.record.contains("Up to date") || data.record.contains("Transferring") {
                    Text(extractDate(from: data.record) ?? "")
                } else {
                    Text("")
                }
            }
        }
        .padding()
    }
    
    func extractDate(from text: String) -> String? {
        let pattern = "[A-Za-z]{3} [A-Za-z]{3} \\d{2} \\d{2}:\\d{2}:\\d{2}"
        if let range = text.range(of: pattern, options: .regularExpression) {
            return String(text[range])
        } else {
            return nil
        }
    }
}

