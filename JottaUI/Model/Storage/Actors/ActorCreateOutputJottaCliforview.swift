//
//  ActorCreateOutputJottaCliforview.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import OSLog

actor ActorCreateOutputJottaCliforview {
    @concurrent
    nonisolated func createaoutputforview(_ stringoutput: [String]?) async -> [JottaCliOutputData] {
        Logger.process.info("ActorCreateOutputJottaCliforview: createaoutputforview() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let stringoutput {
            return stringoutput.map { filename in
                JottaCliOutputData(record: filename)
            }
        }
        return []
    }
}
