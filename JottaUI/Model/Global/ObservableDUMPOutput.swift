//
//  ObservableDUMPOutput.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation
import Observation

@Observable
final class ObservableDUMPOutput {
    @ObservationIgnored var jsondata: JSON?
    // Backup data
    @ObservationIgnored var backups: [Backuproot] = []
    

    func debugJSONdata() {
        if let backuproot: [JSON] = jsondata?["backuproot"].arrayValue {
            for item in backuproot {
                print(item)
            }
        }
    }

    func setJSONstring(_ stringdata: [String]?) {
        if let data = stringdata?.joined(separator: "\n").data(using: .utf8, allowLossyConversion: false) {
            jsondata = try? JSON(data: data)
        }
    }

    func formatted_number(_ number: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
    }
}
