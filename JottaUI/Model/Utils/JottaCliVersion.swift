//
//  JottaCliVersion.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import Foundation
import Observation

@Observable @MainActor
final class JottaCliVersion {
    func getjottacliversion() {
        let arguments = ["version"]
        let clicommand = FullpathJottaCli().jottaclipathandcommand()

        let command = ProcessCommandObserving(command: clicommand,
                                     arguments: arguments,
                                     processtermination: processtermination)
        command.executeProcess()
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

extension JottaCliVersion {
    func processtermination(_ stringoutput: [String]?) {
        guard stringoutput?.count ?? 0 > 0 else { return }
        let jottacliversion = stringoutput?.filter { $0.hasPrefix("jotta-cli version") }.first ?? ""
        let jottadversion = stringoutput?.filter { $0.hasPrefix("jottad version") }.first ?? ""
        SharedReference.shared.jottacliversion = jottacliversion + "\n" + jottadversion
    }
}
