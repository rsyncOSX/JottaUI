//
//  SharedConstants.swift
//  JottaUI
//
//  Created by Thomas Evensen on 29/03/2025.
//

// Sendable
struct SharedConstants: Sendable {
    // Filename logfile
    let logname: String = "jottabackup.log"
    // JottaUI config files and path
    let logfilepath: String = "/.jottad/"
    let jottaUIlogfile: String = "jottaui.txt"
    // 1_000_000 Bytes = 1 MB
    let logfilesize: Int = 1_000_000
}
