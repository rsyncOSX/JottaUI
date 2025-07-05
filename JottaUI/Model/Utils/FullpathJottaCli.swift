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
    func rsyncpath() -> String? {
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
}
