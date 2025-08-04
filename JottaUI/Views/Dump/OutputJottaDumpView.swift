//
//  OutputJottaDumpView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//


import SwiftUI

struct OutputJottaDumpView: View {
    @Binding var jsondata: ObservableDUMPOutput

    var body: some View {
        VStack(alignment: .center) {
            
            Table(jsondata.backups) {
                TableColumn("Path", value: \.Path)
                    // TableColumn("DeviceID", value: \.DeviceID)
                    .width(min: 120, max: 400)

                TableColumn("WaitingForScan") { data in
                    Text(String(data.WaitingForScan))
                }
                .width(min: 50, max: 100)
                .alignment(.trailing)

                TableColumn("Name", value: \.Name)
                    .width(min: 80, max: 200)

                TableColumn("Files") { data in
                    Text(jsondata.formatted_number(data.Count.Files))
                }
                .width(min: 40, max: 80)
                .alignment(.trailing)

                TableColumn("Started") { data in
                    Text(String(dateinseconds(data.history.Started)))
                }
                .width(min: 120, max: 150)
                .alignment(.trailing)

                TableColumn("Ended") { data in
                    Text(String(dateinseconds(data.history.Ended)))
                }
                .width(min: 120, max: 150)
                .alignment(.trailing)

                TableColumn("Finished") { data in
                    Text(String(data.history.Finished))
                }
                .width(min: 50, max: 50)
                .alignment(.trailing)

                TableColumn("LastUpdateMS") { data in
                    Text(dateinmilliseconds(data.LastUpdateMS))
                }
                .width(min: 120, max: 150)
                /*
                 TableColumn("NextBackupMS") { data in
                     Text(dateinmilliseconds(data.NextBackupMS))
                 }
                 .width(min: 80, max: 100)
                 */
                TableColumn("LastScanStartedMS") { data in
                    Text(dateinmilliseconds(data.LastScanStartedMS))
                }
                .width(min: 120, max: 150)
            }
        }
        .padding()
    }

    let dateinmilliseconds: (Int) -> String = { (ms: Int) -> String in
        let date = Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        // dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }

    let dateinseconds: (Int) -> String = { (s: Int) -> String in
        let date = Date(timeIntervalSince1970: TimeInterval(s))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        // dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
