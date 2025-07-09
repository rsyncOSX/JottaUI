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

                    Section {
                        ValueSchemeView(200, jsondata.device?.Name ?? "Device name not set")
                        ValueSchemeView(200, String(jsondata.device?.Type ?? 0))
                    } header: {
                        Text("Device data")
                    }
                }
                .formStyle(.grouped)

                Form {
                    Section {
                        ValueSchemeView(200, jsondata.accountinfo?.ProductNameLocalized ?? "Account data name not set")
                        ValueSchemeView(200, jsondata.accountinfo?.SubscriptionNameLocalized ?? "Account data name not set")

                        ValueSchemeView(200, String(jsondata.accountinfo?.Capacity ?? 0))
                        ValueSchemeView(200, String(jsondata.accountinfo?.Usage ?? 0))
                        ValueSchemeView(200, String(jsondata.accountinfo?.Subscription ?? 0))

                        ValueSchemeView(200, String(jsondata.accountinfo?.CanUpgrade ?? false))
                        ValueSchemeView(200, String(jsondata.accountinfo?.UpgradeHint ?? false))

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

                TableColumn("Name", value: \.Name)
                    .width(min: 80, max: 200)

                TableColumn("Files") { data in
                    Text(String(data.Count.Files))
                }
                .width(min: 40, max: 80)
                .alignment(.trailing)

                TableColumn("Started") { data in
                    Text(String(data.history.Started))
                }
                .width(min: 60, max: 100)
                .alignment(.trailing)

                TableColumn("Ended") { data in
                    Text(String(data.history.Ended))
                }
                .width(min: 60, max: 100)
                .alignment(.trailing)

                TableColumn("Finished") { data in
                    Text(String(data.history.Finished))
                }
                .width(min: 50, max: 50)
                .alignment(.trailing)

                TableColumn("LastUpdateMS") { data in
                    Text(dateinseconds(data.LastUpdateMS))
                }
                .width(min: 80, max: 100)

                TableColumn("NextBackupMS") { data in
                    Text(dateinseconds(data.NextBackupMS))
                }
                .width(min: 80, max: 100)

                TableColumn("LastScanStartedMS") { data in
                    Text(dateinseconds(data.LastScanStartedMS))
                }
                .width(min: 80, max: 100)
            }
        }
        .padding()
    }

    let dateinseconds: (Int) -> String = { (ms: Int) -> String in
        let date = Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
