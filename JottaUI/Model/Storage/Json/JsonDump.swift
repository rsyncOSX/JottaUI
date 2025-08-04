//
//  JsonDump.swift
//  JottaUI
//
//  Created by Thomas Evensen on 04/08/2025.
//

import Foundation

struct Backuproot: Identifiable {
    let id = UUID()
    var backuproot: String
    var folder: String
    var files: [Files]
}

struct Files: Identifiable {
    let id = UUID()
    var name: String
    var md5: String
    var size: Int
}
