//
//  JottaUIApp.swift
//
//  Created by Thomas Evensen on 12/01/2021.
//

import OSLog
import SwiftUI

@main
struct JottaUIApp: App {
    var body: some Scene {
        Window("JottaUI", id: "main") {
            JottaUIView()
                .frame(minWidth: 1180, idealWidth: 1360, minHeight: 700)
        }
        .commands {
            SidebarCommands()

            ImportExportCommands()
        }
    }
}

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier
    static let process = Logger(subsystem: subsystem ?? "process", category: "process")

    func errorMessageOnly(_ message: String) {
        #if DEBUG
            error("\(message)")
        #endif
    }

    func debugMessageOnly(_ message: String) {
        #if DEBUG
            debug("\(message)")
        #endif
    }

    func debugThreadOnly(_ message: String) {
    #if DEBUG
        debug("\(message) isolation: \(Thread.isMainThread ? "main" : "background on \(Thread.current)")")
    #endif
    }
}
