//
//  SharedReference.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 05.09.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation
import Observation

public extension Thread {
    static var isMain: Bool { isMainThread }
    static var currentThread: Thread { Thread.current }
}

public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

@Observable
final class SharedReference {
    @MainActor static let shared = SharedReference()

    private init() {}

    // Mac serialnumer
    @ObservationIgnored var macserialnumber: String?
    // let bundleIdentifier: String = "no.blogspot.JottaUI"
    let jottaclient = "jotta-cli"
    let usrlocalbin: String = "/usr/local/bin"
    let usrlocalbinarm: String = "/opt/homebrew/bin"
    @ObservationIgnored var macosarm: Bool = false
    // Reference to the active process
    var process: Process?
    // Object for propogate errors to views
    @ObservationIgnored var errorobject: AlertError?
    var jottacliversion: String?
}
