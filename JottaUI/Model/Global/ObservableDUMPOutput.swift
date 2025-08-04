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
    
    func setJSONstring(_ stringdata: [String]?) -> [Backuproot]? {
        var backuproot: [Backuproot]?
        Task {
            if let stringdata {
                async let data = ActorConvertDumpData().convertStringToData(stringdata)
                backuproot = await ActorConvertDumpData().convertDataToBackup(data)
                return backuproot
            }
            return nil
        }
        return nil
    }
}
