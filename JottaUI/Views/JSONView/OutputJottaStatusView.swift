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
                TableColumn("Name", value: \.Name)
                TableColumn("Files") { data in
                    Text(String(data.Count.Files))
                }
                TableColumn("Bytes") { data in
                    Text(String(data.Count.Bytes))
                }

                TableColumn("LastUpdateMS") { data in
                    Text(dateinseconds(data.LastUpdateMS))
                }

                TableColumn("NextBackupMS") { data in
                    Text(dateinseconds(data.NextBackupMS))
                }

                TableColumn("LastScanStartedMS") { data in
                    Text(dateinseconds(data.LastScanStartedMS))
                }
            }
        }
        .padding()
    }

    let dateinseconds: (Int) -> String = { (ms: Int) -> String in
        let date = Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
