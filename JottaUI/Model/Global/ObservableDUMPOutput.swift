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
    @ObservationIgnored var backups: [Backuproot] = []
    
    func setJSONstring(_ stringdata: [String]?) {
        Task {
            if let stringdata {
                async let data = ActorConvertDumpData().convertStringToData(stringdata)
                let test = await ActorConvertDumpData().convertDataToBackup(data)
            }
        }
    }
}
