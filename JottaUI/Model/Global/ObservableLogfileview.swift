//
//  ObservableLogfileview.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import Foundation
import Observation

struct LogfileRecords: Identifiable {
    let id = UUID()
    var logrecordline: String
    var logrecordlogdate: Date?
}

@Observable @MainActor
final class ObservableLogfileview {
    var output: [LogfileRecords]?
}
