//
//  ActorConvertDumpData.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation
import OSLog

actor ActorConvertDumpData {
    
    @concurrent
    nonisolated func convertStringToData(_ stringarray: [String]) async -> [Data] {
        Logger.process.info("ActorConvertDumpData: convertStringToData() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        var convertedData = [Data]()
        for i in 0 ..< stringarray.count {
            if let data = stringarray[i].data(using: .utf8) {
                convertedData.append(data)
            }
        }
        return convertedData
    }
    
    @concurrent
    nonisolated func convertDataToBackup(_ dataarray: [Data]) async -> [Backuproot] {
        Logger.process.info("ActorConvertDumpData: convertDataToBackup() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        var converted = [Backuproot]()
        for i in 0 ..< dataarray.count {
            
            let jsondata = try? JSON(data: dataarray[i])
            
            print(jsondata?["folder"])
            print(jsondata?["backuproot"])
            
            if let files: [JSON] = jsondata?["files"].arrayValue {
                for file in files {
                    print(file["md5"])
                    print(file["size"].intValue)
                    print(file["name"])
                }
            }
        }
        return converted
    }
    
    
    func formatted_number(_ number: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
    }
}
