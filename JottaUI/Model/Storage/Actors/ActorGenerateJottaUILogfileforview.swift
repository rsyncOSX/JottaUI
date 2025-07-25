import OSLog

actor ActorGenerateJottaUILogfileforview {
    @concurrent
    nonisolated func generatedata() async -> [LogfileRecords] {
        Logger.process.info("ActorGenerateJottaUILogfileforview: generatedata() MAIN THREAD: \(Thread.isMain) but on \(Thread.current)")
        if let data = await ActorJottaUILogToFile(false).readloggfile() {
            return data.map { record in
                LogfileRecords(logrecordline: record)
            }
        } else {
            return []
        }
    }
}
