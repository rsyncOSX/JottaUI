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
                .frame(minWidth: 1100, idealWidth: 1300, minHeight: 510)
        }
        .commands {
            SidebarCommands()

            ImportExportCommands()
        }
    }
}

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let process = Logger(subsystem: subsystem, category: "process")

    func debugmesseageonly(_ message: String) {
        #if DEBUG
            debug("\(message)")
        #endif
    }

    func debugtthreadonly(_ message: String) {
        #if DEBUG
            if Thread.checkIsMainThread() {
                debug("\(message) Running on main thread")
            } else {
                debug("\(message) NOT on main thread, currently on \(Thread.current)")
            }
        #endif
    }
}
