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
                    if data.record.contains(strings.uptodate) {
                        if seconds > 0 {
                            if seconds > 3600 {
                                let hours = String(format: "%.2f", seconds / 3600)
                                Text(data.record) + Text(" (\(hours) hours ago)")
                                    .foregroundColor(Color.green)
                            } else {
                                let minutessince = String(format: "%.2f", seconds / 60)
                                Text(data.record) + Text(" (\(minutessince) min ago)")
                                    .foregroundColor(Color.green)
                            }
                        } else {
                            Text(data.record)
                        }
                    } else if data.record.contains(strings.transferring) {
                        Text(data.record)
                            .foregroundColor(Color.yellow)
                    } else if data.record.contains(strings.waiting) {
                        Text(data.record)
                            .foregroundColor(Color.yellow)
                    } else if data.record.contains(strings.performingUpdates) {
                        Text(data.record)
                            .foregroundColor(Color.yellow)
                    } else if data.record.contains(strings.haveNotBeenBackedUp) {
                        Text(data.record)
                            .foregroundColor(Color.red)
                    } else if data.record.contains(strings.nobytes) {
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

    var strings: SharedStrings {
        SharedStrings()
    }
}
