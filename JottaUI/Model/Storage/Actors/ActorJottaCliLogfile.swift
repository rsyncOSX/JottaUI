//
//  ActorJottaCliLogfile.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorJottaCliLogfile {
    @concurrent
    nonisolated func jottaclilogfile() async -> [LogfileRecords] {
        Logger.process.debugtthreadonly("ActorJottaCliLogfile: jottaclilogfile() ")
        if let data = await ActorReadJottaCliLogfile().readloggfile() {
            let logdata = data.compactMap { record in
                let parts = record.split(separator: " ")
                if parts.count > 3 {
                    let dateString = String(parts[1] + " " + parts[2])
                    // return Compact map
                    return LogfileRecords(logrecordline: record, logrecordlogdate: dateString.date_from_string())
                } else {
                    return nil
                }
            }
            // Sort logdata, most recent at top
            return logdata.sorted { record1, record2 -> Bool in
                if let date1 = record1.logrecordlogdate, let date2 = record2.logrecordlogdate {
                    return date1 > date2
                }
                return false
            }

        } else {
            return []
        }
    }

    @concurrent
    nonisolated func sortjottaclilogfile(_ direction: Bool) async -> [LogfileRecords] {
        Logger.process.debugtthreadonly("ActorJottaCliLogfile: sortjottaclilogfile() ")
        if let data = await ActorReadJottaCliLogfile().readloggfile() {
            let logdata = data.compactMap { record in
                let parts = record.split(separator: " ")
                if parts.count > 3 {
                    let dateString = String(parts[1] + " " + parts[2])
                    // return Compact map
                    return LogfileRecords(logrecordline: record, logrecordlogdate: dateString.date_from_string())
                } else {
                    return nil
                }
            }

            if direction {
                // Most recent at op
                return logdata.sorted { record1, record2 -> Bool in
                    if let date1 = record1.logrecordlogdate, let date2 = record2.logrecordlogdate {
                        return date1 > date2
                    }
                    return false
                }
            } else {
                // The other way
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
