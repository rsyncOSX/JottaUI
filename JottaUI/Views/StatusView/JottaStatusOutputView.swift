//
//  JottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 20/11/2023.
//

import SwiftUI

struct JottaStatusOutputView: View {
    var output: [JottaCliOutputData]

    var body: some View {
        Table(output) {
            TableColumn("Status Jotta-cli" + ": \(output.count) rows") { data in
                
                var seconds: Double {
                    if var date = extractDate(from: data.record), let year = Date().year() {
                        date = String(year) + " " + date
                        if let lastbackup = date.status_date_from_string() {
                            return lastbackup.timeIntervalSinceNow * -1
                        }
                        
                    } else {
                        return 0
                    }
                    return 0
                }
                
                
                if data.record.contains("------") {
                    Text("")
                } else {
                    if data.record.contains("Up to date") {
                        HStack {
                            Text(data.record)
                                .foregroundColor(Color.green)
                            
                            if seconds > 0 {
                                Text(String(format: "%.2f", seconds / 60))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            Spacer()
                        }
                        
                    } else if data.record.contains("Transferring") {
                        
                        HStack {
                            
                            Text(data.record)
                                .foregroundColor(Color.red)
                            
                            if seconds > 0 {
                                Text(String(format: "%.2f", seconds / 60))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            Spacer()
                        }
                        
                        
                    } else {
                        HStack {
                            
                            Text(data.record)
                            
                            if seconds > 0 {
                                Text(String(format: "%.2f", seconds / 60))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            Spacer()
                        }
                    }
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
