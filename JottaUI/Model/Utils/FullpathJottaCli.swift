//
//  FullpathJottaCli.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 06/06/2019.
//  Copyright © 2019 Thomas Evensen. All rights reserved.
//

import Foundation
import OSLog

@MainActor
struct FullpathJottaCli {
    func jottaclipathandcommand() -> String {
        if SharedReference.shared.macosarm {
            Logger.process.info("GetfullpathforRsync HOMEBREW path ARM: \(SharedReference.shared.usrlocalbinarm.appending("/"), privacy: .public)")
        } else {
            Logger.process.info("GetfullpathforRsync HOMEBREW path INTEL: \(SharedReference.shared.usrlocalbin.appending("/"), privacy: .public)")
        }
        if SharedReference.shared.macosarm {
            return SharedReference.shared.usrlocalbinarm.appending("/") + SharedReference.shared.jottaclient
        } else {
            return SharedReference.shared.usrlocalbin.appending("/") + SharedReference.shared.jottaclient
        }
    }
    
    init() {
        let silicon = ProcessInfo().machineHardwareName?.contains("arm64") ?? false
        if silicon {
            SharedReference.shared.macosarm = true
        } else {
            SharedReference.shared.macosarm = false
        }
    }
}

extension ProcessInfo {
    /// Returns a `String` representing the machine hardware name or nil if there was an error invoking `uname(_:)`
    ///  or decoding the response. Return value is the equivalent to running `$ uname -m` in shell.
    var machineHardwareName: String? {
        var sysinfo = utsname()
        let result = uname(&sysinfo)
        guard result == EXIT_SUCCESS else { return nil }
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let identifier = String(bytes: data, encoding: .ascii) else { return nil }
        return identifier.trimmingCharacters(in: .controlCharacters)
    }
}
