//
//  ActorGenerateJottaCliLogfileforview.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorGenerateJottaCliLogfileforview {
    @concurrent
    nonisolated func generatedata() async -> [LogfileRecords] {
        Logger.process.info("ActorGenerateJottaCliLogfileforview: generatedata() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let data = await ActorReadJottaCliLogfile().readloggfile() {
            return data.compactMap { record in
                let parts = record.split(separator: " ")
                if parts.count > 3 {
                    let dateString = String(parts[1] + " " + parts[2])
                    return LogfileRecords(logrecordline: record, logrecordlogdate: dateString.date_from_string())
                } else {
                    return nil
                }
            }
        } else {
            return []
        }
    }

    @concurrent
    nonisolated func sortlogdata(_ direction: Bool) async -> [LogfileRecords] {
        Logger.process.info("ActorGenerateJottaCliLogfileforview: sortlogdata() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let data = await ActorReadJottaCliLogfile().readloggfile() {
            let logdata = data.compactMap { record in
                let parts = record.split(separator: " ")
                if parts.count > 3 {
                    let dateString = String(parts[1] + " " + parts[2])
                    return LogfileRecords(logrecordline: record, logrecordlogdate: dateString.date_from_string())
                } else {
                    return nil
                }
            }

            if direction {
                return logdata.sorted { record1, record2 -> Bool in
                    if let date1 = record1.logrecordlogdate, let date2 = record2.logrecordlogdate {
                        return date1 > date2
                    }
                    return false
                }
            } else {
                return logdata.sorted { record1, record2 -> Bool in
                    if let date1 = record1.logrecordlogdate, let date2 = record2.logrecordlogdate {
                        return date1 < date2
                    }
                    return false
                }
            }
        } else {
            return []
        }
    }
}
