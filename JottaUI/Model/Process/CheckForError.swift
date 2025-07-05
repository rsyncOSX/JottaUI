//
//  CheckForError.swift
//  JottaUI
//
//  Created by Thomas Evensen on 03/07/2025.
//

import Foundation

enum JottaCliError: LocalizedError {
    case clierror

    var errorDescription: String? {
        switch self {
        case .clierror:
            "There are errors in output from Jotta-cli"
        }
    }
}

@MainActor
final class CheckForError {
    var trimmeddata: [String]?

    // Check for error in output form rsync
    func checkforerror(_ line: String) throws {
        let error = line.contains("Error") || line.contains("error")
        if error {
            throw JottaCliError.clierror
        }
    }

    init() {}
}
