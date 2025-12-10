//
//  JottaStatusJsonOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 05/07/2025.
//

import SwiftUI

struct JottaStatusJsonOutputView: View {
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
                        let productName = jsondata.accountinfo?.ProductNameLocalized ?? "Account data name not set"
                        ValueSchemeView(200, productName)
                        let capacity = jsondata.accountinfo?.Capacity ?? 0
                        ValueSchemeView(200, "available " + jsondata.formatted_number_GiB(capacity) + " GiB")
                        let usage = jsondata.accountinfo?.Usage ?? 0
                        let used = jsondata.formatted_number_GiB(usage)
                        ValueSchemeView(200, "used " + used + " GiB")

                    } header: {
                        Text("Account data")
                    }
                }
                .formStyle(.grouped)
            }

            Table(jsondata.backups) {
                TableColumn("Catalogs", value: \.Path)
                    .width(min: 120, max: 400)

                TableColumn("Wait scan") { data in
                    if data.WaitingForScan {
                        Text(String(data.WaitingForScan))
                            .foregroundColor(Color.green)
                    } else {
                        Text(String(data.WaitingForScan))
                    }
                }
                .width(min: 70, max: 70)
                .alignment(.trailing)
                /*
                 TableColumn("Catalogs", value: \.Name)
                     .width(min: 80, max: 200)
                 */
                TableColumn("Files") { data in
                    Text(jsondata.formatted_number(data.Count.Files))
                }
                .width(min: 40, max: 80)
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

                TableColumn("Last scan") { data in
                    Text(dateinmilliseconds(data.LastScanStartedMS))
                }
                .width(min: 120, max: 150)
            }
            .padding()
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

    let dateinseconds: (Int) -> String = { (seconds: Int) -> String in
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        // dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
