//
//  ActorCreateOutputforview.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorCreateOutputforview {
    @concurrent
    nonisolated func createaoutput(_ stringoutput: [String]?) async -> [JottaCliOutputData] {
        Logger.process.info("ActorCreateOutputforview: createaoutput() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let stringoutput {
            return stringoutput.map { filename in
                JottaCliOutputData(record: filename)
            }
        }
        return []
    }
    
    @concurrent
    nonisolated func createoutputlogdata() async -> [LogfileRecords] {
        Logger.process.info("ActorCreateOutputforview: createoutputlogdata() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let data = await ActorJottaUILogToFile(false).readloggfile() {
            return data.map { record in
                LogfileRecords(logrecordline: record)
            }
        } else {
            return []
        }
    }
}
