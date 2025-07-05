//
//  ObservableJSONStatus.swift
//  JottaUI
//
//  Created by Thomas Evensen on 03/07/2025.
//

import Foundation
import Observation

@Observable
final class ObservableJSONStatus {
    @ObservationIgnored var jsondata: JSON?
    // User data
    @ObservationIgnored var userdata: User?
    // Backup data
    @ObservationIgnored var backups: [Backup] = []
    // Helpers
    @ObservationIgnored var device: Device?
    @ObservationIgnored var avatar: Avatar?
    @ObservationIgnored var accountinfo: AccountInfo?
    @ObservationIgnored var background: Background?

    func debugJSONdata() {
        if let user: JSON = jsondata?["User"] {
            device = Device(Type: user["device"]["Type"].intValue,
                            Name: user["device"]["Name"].stringValue)
            background = Background(r: user["Avatar"]["Background"]["r"].intValue,
                                    g: user["Avatar"]["Background"]["g"].intValue,
                                    b: user["Avatar"]["Background"]["b"].intValue)
            accountinfo = AccountInfo(Capacity: user["AccountInfo"]["Capacity"].intValue,
                                      Usage: user["AccountInfo"]["Usage"].intValue,
                                      Subscription: user["AccountInfo"]["Subscription"].intValue,
                                      CanUpgrade: user["AccountInfo"]["CanUpgrade"].boolValue,
                                      UpgradeHint: user["AccountInfo"]["UpgradeHint"].boolValue,
                                      SubscriptionNameLocalized: user["AccountInfo"]["SubscriptionNameLocalized"].stringValue,
                                      ProductNameLocalized: user["AccountInfo"]["ProductNameLocalized"].stringValue)
            avatar = Avatar(Background: background!,
                            Initials: user["Avatar"]["Initials"].stringValue)

            if let avatar, let accountinfo, let device {
                userdata = User(Email: user["Email"].stringValue,
                                Fullname: user["Fullname"].stringValue,
                                Avatar: avatar,
                                Brand: user["Brand"].stringValue,
                                Hostname: user["Hostname"].stringValue,
                                AccountInfo: accountinfo,
                                device: device)
            } else {
                userdata = User(Email: user["Email"].stringValue,
                                Fullname: user["Fullname"].stringValue,
                                Avatar: nil,
                                Brand: user["Brand"].stringValue,
                                Hostname: user["Hostname"].stringValue,
                                AccountInfo: nil,
                                device: nil)
            }

            if let backuplist: [JSON] = jsondata?["Backups"].arrayValue {
                for item in backuplist {
                    // History start
                    let historyitem = item["History"]
                    // Upload Started
                    let sbytes = historyitem[0]["Upload"]["Started"]["Bytes"].intValue
                    let sfiles = historyitem[0]["Upload"]["Started"]["Files"].intValue
                    // Upload Completed
                    let cbytes = historyitem[0]["Upload"]["Completed"]["Bytes"].intValue
                    let cfiles = historyitem[0]["Upload"]["Completed"]["Files"].intValue
                    // Upload itself
                    let upload = Upload(Started: Started(Files: sbytes, Bytes: sfiles),
                                        Completed: Completed(Files: cbytes, Bytes: cfiles))

                    let finished = historyitem[0]["Finished"].boolValue
                    let started = historyitem[0]["Started"].intValue
                    let hpath = historyitem[0]["Path"].stringValue

                    let tbytes = historyitem[0]["Total"]["Bytes"].intValue
                    let tfiles = historyitem[0]["Total"]["Files"].intValue
                    let total = Total(Bytes: tbytes, Files: tfiles)
                    let ended = historyitem[0]["Ended"].intValue

                    let history = History(Ended: ended, Started: started, Path: hpath, Upload: upload, Total: total, Finished: finished)
                    // History ended

                    let NextBackupMS = item["NextBackupMS"].intValue
                    let LastUpdateMS = item["LastUpdateMS"].intValue
                    let path = item["Path"].stringValue
                    // Count in Backup
                    let countfiles = item["Count"]["Files"].intValue
                    let countbytes = item["Count"]["Bytes"].intValue
                    let count = Count(Bytes: countbytes, Files: countfiles)

                    let DeviceID = item["DeviceID"].stringValue
                    let LastScanStartedMS = item["LastScanStartedMS"].intValue
                    let name = item["Name"].stringValue

                    let backupitem = Backup(LastUpdateMS: LastUpdateMS,
                                            NextBackupMS: NextBackupMS,
                                            Count: count,
                                            Path: path,
                                            history: history,
                                            DeviceID: DeviceID,
                                            LastScanStartedMS: LastScanStartedMS,
                                            Name: name)
                    backups.append(backupitem)
                }
            }
        }
    }

    func setJSONstring(_ stringdata: [String]?) {
        if let data = stringdata?.joined(separator: "\n").data(using: .utf8, allowLossyConversion: false) {
            jsondata = try? JSON(data: data)
        }
    }

    func setJSONData(_ data: Data) {
        jsondata = try? JSON(data: data)
    }
}
