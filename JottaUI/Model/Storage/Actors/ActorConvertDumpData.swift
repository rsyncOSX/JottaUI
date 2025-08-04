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
            
            var fileitem: Files?
            var fileitems: [Files]?
            var backuprootitem: Backuproot?
            
            let jsondata = try? JSON(data: dataarray[i])
            
            if let files: [JSON] = jsondata?["files"].arrayValue {
                fileitems = [Files]()
                for file in files {
                    fileitem = Files(name: file["name"].stringValue,
                                  md5: file["md5"].stringValue,
                                  size: file["size"].intValue)
                    if let fileitem {
                        fileitems?.append(fileitem)
                    }
                    
                }
            }
            if let fileitems,
                let backuproot = jsondata?["backuproot"].stringValue,
                let folder = jsondata?["folder"].stringValue {
                backuprootitem = Backuproot(backuproot: backuproot,
                                        folder: folder,
                                        files: fileitems)
                if let backuprootitem {
                    converted.append(backuprootitem)
                }
            }
        }
        return converted
    }
    
    
    func formatted_number(_ number: Int) -> String {
        NumberFormatter.localizedString(from: NSNumber(value: number), number: NumberFormatter.Style.decimal)
    }
}
