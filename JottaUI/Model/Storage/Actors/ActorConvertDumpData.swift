//
//  ActorConvertDumpData.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation
import OSLog

actor ActorConvertDumpData {
    let gitcatalog = "/.git"

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
    nonisolated func convertDataToBackup(_ dataarray: [Data], _ excludegit: Bool) async -> [Files] {
        Logger.process.info("ActorConvertDumpData: convertDataToBackup() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        var converted = [Files]()
        for i in 0 ..< dataarray.count {
            var fileitem: Files?
            let jsondata = try? JSON(data: dataarray[i])

            let backuproot = jsondata?["backuproot"].stringValue
            let folder = jsondata?["folder"].stringValue

            if let files: [JSON] = jsondata?["files"].arrayValue,
               let backuproot, let folder
            {
                for file in files {
                    fileitem = Files(backuproot: backuproot,
                                     folder: folder,
                                     name: file["name"].stringValue,
                                     md5: file["md5"].stringValue,
                                     size: file["size"].intValue)
                    if let fileitem, excludegit == false {
                        converted.append(fileitem)
                    } else if let fileitem, fileitem.folder.contains(gitcatalog) == false {
                        converted.append(fileitem)
                    }
                }
            }
        }
        return converted
    }
}
