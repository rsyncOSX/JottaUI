//
//  SharedStrings.swift
//  JottaUI
//
//  Created by Thomas Evensen on 09/09/2025.
//

// Sendable
struct SharedStrings: Sendable {
    // Strings for jotta-cli status view, not JSON status
    let uptodate = "Up to date"
    let transferring = "Transferring"
    let waiting = "Waiting"
    let performingUpdates = "Performing updates"
    let haveNotBeenBackedUp = "have not been backed up"

    // Strings for Process object, strings which requiere a second input
    let continueSyncSetup = "Continue sync setup?"
    let chooseErrorReportingMode = "Choose error reporting mode"
    let continueSyncReset = "Continue sync reset"
    let theExistingSyncFolderOnJottacloudCom = "The existing sync folder on jottacloud.com"
}
