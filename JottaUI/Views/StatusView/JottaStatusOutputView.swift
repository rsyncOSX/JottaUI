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
                        if seconds > 0 {
                            let minutessince = String(format: "%.2f", seconds / 60)

                            Text(data.record) + Text(" (\(minutessince) min ago)")
                                .foregroundColor(Color.green)

                        } else {
                            Text(data.record)
                        }

                    } else if data.record.contains("Transferring") {
                        Text(data.record)
                            .foregroundColor(Color.red)
                    } else {
                        Text(data.record)
                    }
                }
            }
        }
        .padding()
    }

    func extractDate(from string: String) -> String? {
        // Regular expression to match the date-time pattern
        let pattern = #"[A-Za-z]{3} [A-Za-z]{3} \d{1,2} \d{2}:\d{2}:\d{2}"#
        
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        
        if let match = regex?.firstMatch(in: string, range: range) {
            let matchRange = Range(match.range, in: string)!
            return String(string[matchRange])
        }
        
        return nil
    }
}
