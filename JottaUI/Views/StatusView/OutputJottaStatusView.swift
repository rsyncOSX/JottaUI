//
//  OutputJottaStatusView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 05/07/2025.
//

import SwiftUI

struct OutputJottaStatusView: View {
    @Binding var jsondata: ObservableJSONStatus

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Form {
                    Section {
                        ValueSchemeView(200, jsondata.userdata?.Email ?? "Email not set")
                        ValueSchemeView(200, jsondata.userdata?.Fullname ?? "Fullname not set")
                        ValueSchemeView(200, jsondata.userdata?.Brand ?? "Brand not set")
                        ValueSchemeView(200, jsondata.userdata?.Hostname ?? "Hostname not set")
                    } header: {
                        Text("User data")
                    }
                }
                .formStyle(.grouped)

                Form {
                    Section {
                        ValueSchemeView(200, jsondata.accountinfo?.ProductNameLocalized ?? "Account data name not set")
                        // ValueSchemeView(200, jsondata.accountinfo?.SubscriptionNameLocalized ?? "Account data name not set")
                        ValueSchemeView(200, "available " + jsondata.formatted_number_GiB(jsondata.accountinfo?.Capacity ?? 0) + " GiB")
                        ValueSchemeView(200, "used " + jsondata.formatted_number_GiB(jsondata.accountinfo?.Usage ?? 0) + " GiB")
                        // ValueSchemeView(200, String(jsondata.accountinfo?.Subscription ?? 0))
                        // ValueSchemeView(200, String(jsondata.accountinfo?.CanUpgrade ?? false))
                        // ValueSchemeView(200, String(jsondata.accountinfo?.UpgradeHint ?? false))

                    } header: {
                        Text("Account data")
                    }
                }
                .formStyle(.grouped)
            }

            Table(jsondata.backups) {
                TableColumn("Path", value: \.Path)
                    // TableColumn("DeviceID", value: \.DeviceID)
                    .width(min: 120, max: 400)

                TableColumn("Wait scan") { data in
                    Text(String(data.WaitingForScan))
                }
                .width(min: 50, max: 100)
                .alignment(.trailing)

                TableColumn("Catalogs", value: \.Name)
                    .width(min: 80, max: 200)

                TableColumn("Files") { data in
                    Text(jsondata.formatted_number(data.Count.Files))
                }
                .width(min: 40, max: 80)
                .alignment(.trailing)

                TableColumn("Start") { data in
                    Text(String(dateinseconds(data.history.Started)))
                }
                .width(min: 120, max: 150)
                .alignment(.trailing)

                TableColumn("End") { data in
                    Text(String(dateinseconds(data.history.Ended)))
                }
                .width(min: 120, max: 150)
                .alignment(.trailing)

                TableColumn("Finished") { data in
                    Text(String(data.history.Finished))
                }
                .width(min: 50, max: 50)
                .alignment(.trailing)

                TableColumn("Last update") { data in
                    Text(dateinmilliseconds(data.LastUpdateMS))
                }
                .width(min: 120, max: 150)
                /*
                 TableColumn("NextBackupMS") { data in
                     Text(dateinmilliseconds(data.NextBackupMS))
                 }
                 .width(min: 80, max: 100)
                 */
                TableColumn("Last scan") { data in
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
