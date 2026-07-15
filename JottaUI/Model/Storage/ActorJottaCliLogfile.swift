//
//  ActorJottaCliLogfile.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorJottaCliLogfile {
    func jottaclilogfile() async -> [LogfileRecords] {
        Logger.process.debugThreadOnly("ActorJottaCliLogfile: jottaclilogfile() ")

        let data: [String]? = await Task.detached {
            try? ReadJottaCliLogfile().readloggfile()
        }.value

        guard let data else { return [] }

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

        return logdata.sorted {
            ($0.logrecordlogdate ?? .distantPast) >
                ($1.logrecordlogdate ?? .distantPast)
        }
    }

    func sortjottaclilogfile(direction: Bool) async -> [LogfileRecords] {
        Logger.process.debugThreadOnly("ActorJottaCliLogfile: sortjottaclilogfile() ")

        let data: [String]? = await Task.detached {
            try? ReadJottaCliLogfile().readloggfile()
        }.value

        guard let data else { return [] }

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
            return logdata.sorted {
                ($0.logrecordlogdate ?? .distantPast) >
                    ($1.logrecordlogdate ?? .distantPast)
            }
        } else {
            return logdata.sorted {
                ($0.logrecordlogdate ?? .distantPast) <
                    ($1.logrecordlogdate ?? .distantPast)
            }
        }
    }
}
