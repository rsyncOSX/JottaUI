//
//  ObservableOutputfromJottacli.swift
//  JottaUI
//
//  Created by Thomas Evensen on 01/07/2025.
//

import SwiftUI

struct JottaCliOutputData: Identifiable, Equatable, Hashable {
    let id = UUID()
    var record: String
}

@Observable @MainActor
final class ObservableOutputfromJottacli {
    var output: [JottaCliOutputData]?
}
