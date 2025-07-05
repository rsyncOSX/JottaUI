//
//  JottaUIApp.swift
//
//  Created by Thomas Evensen on 12/01/2021.
//
// swiftlint:disable multiple_closures_with_trailing_closure

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
        }
    }
}

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let process = Logger(subsystem: subsystem, category: "process")
}

// swiftlint:enable multiple_closures_with_trailing_closure
