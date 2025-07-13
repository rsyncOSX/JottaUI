//
//  JsonStatus.swift
//  JottaUI
//
//  Created by Thomas Evensen on 02/07/2025.
//

import Foundation

struct JsonStatus {
    let User: User
    let Backups: [Backup]
    let Sync: Sync
    let State: state
}

struct User {
    let Email: String
    let Fullname: String
    let Avatar: Avatar?
    let Brand: String
    let Hostname: String
    let AccountInfo: AccountInfo?
    let device: Device?
}

struct Avatar {
    let Background: Background
    let Initials: String
}

struct Background {
    let r: Int
    let g: Int
    let b: Int
}

struct AccountInfo {
    let Capacity: Int
    let Usage: Int
    let Subscription: Int
    let CanUpgrade: Bool
    let UpgradeHint: Bool
    let SubscriptionNameLocalized: String
    let ProductNameLocalized: String
}

struct Device {
    let `Type`: Int
    let Name: String
}

struct History {
    let Ended: Int
    let Started: Int
    let Path: String
    let Upload: Upload
    let Total: Total
    let Finished: Bool
}

struct Upload {
    let Started: Started
    let Completed: Completed
}

struct Started {
    let Files: Int
    let Bytes: Int
}

struct Completed {
    let Files: Int
    let Bytes: Int
}

struct Total {
    let Bytes: Int
    let Files: Int
}

struct Count {
    let Bytes: Int
    let Files: Int
}

struct Backup: Identifiable {
    let id = UUID()
    // let Errors: Errors
    // let ErrorFilesCount: ErrorFilesCount
    let LastUpdateMS: Int
    let NextBackupMS: Int
    let Count: Count
    let Path: String
    // let Uploading: Uploading
    let history: History
    let DeviceID: String
    let LastScanStartedMS: Int
    let Name: String
    let WaitingForScan: Bool
}

struct Errors {
    let Count: Int
}

struct Uploading {
    let Count: Int
}

struct ErrorFilesCount {
    let Count: Int
}

struct Sync {
    let Count: Int
    let RemoteCount: Int
}

struct state {
    let RestoreWorking: Bool
    let Uploading: Int
    let Downloading: Int
    let LastTokenRefresh: Int
}
