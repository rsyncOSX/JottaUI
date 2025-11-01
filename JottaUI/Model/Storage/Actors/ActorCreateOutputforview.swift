//
//  ActorCreateOutputforview.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorCreateOutputforview {
    @concurrent
    nonisolated func syncisenabled(_ stringoutput: [String]) async -> Bool {
        let result: [String] = stringoutput.compactMap { line in
            let syncisenabled = String(line)
            return syncisenabled.replacingOccurrences(of: " ", with: "").contains("Sync:") ? line : nil
        }
        if result.isEmpty {
            return false
        } else {
            return true
        }
    }

    // The input containes newlines and must be breaked up
    @concurrent
    nonisolated func createaoutputnewlines(_ stringoutput: [String]?) async -> [JottaCliOutputData] {
        Logger.process.info("ActorCreateOutputforview: createaoutput() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let stringoutput {
            return stringoutput.flatMap { line in
                line.components(separatedBy: .newlines)
                    .filter { !$0.isEmpty } // Optional: remove empty lines
                    .map { subline in
                        JottaCliOutputData(record: subline)
                    }
            }
        }
        return []
    }

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
