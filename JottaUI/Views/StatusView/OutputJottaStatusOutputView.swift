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
    
    
    /*
     import Foundation

     let text = "Status: up to date - Tue Aug 26 12:52:20"
     let pattern = "[A-Za-z]{3} [A-Za-z]{3} \\d{2} \\d{2}:\\d{2}:\\d{2}"

     if let range = text.range(of: pattern, options: .regularExpression) {
         let dateString = String(text[range])
         print("Extracted date and time:", dateString)
     } else {
         print("No date found.")
     }
     
     Explanation of the regex:

     [A-Za-z]{3}: Three-letter day ("Tue")
     [A-Za-z]{3}: Three-letter month ("Aug")
     \\d{2}: Two-digit day ("26")
     \\d{2}:\\d{2}:\\d{2}: Time in HH:MM:SS format ("12:52:20")
     This will extract "Tue Aug 26 12:52:20" from your string. If your date format varies, let me know and I can help adjust the regex!

     */
}
