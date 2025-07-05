//
//  MockdataJson.swift
//  JottaUI
//
//  Created by Thomas Evensen on 05/07/2025.
//

struct MockdataJson {
    let json = """
    {
      "User": {
        "Email": "thomeven@gmail.com",
        "Fullname": "Thomas Evensen",
        "Avatar": {
          "Initials": "TE",
          "Background": {
            "r": 255,
            "g": 121,
            "b": 255
          }
        },
        "Brand": "Jottacloud",
        "Hostname": "Thomas-sin-MacBook-Pro.local",
        "AccountInfo": {
          "Capacity": 1000000000000,
          "Usage": 416050955822,
          "Subscription": 1,
          "CanUpgrade": true,
          "UpgradeHint": true,
          "SubscriptionNameLocalized": "Home subscription 1 TB",
          "ProductNameLocalized": "Home subscription 1 TB"
        },
        "device": {
          "Name": "mac.lan",
          "Type": 12
        }
      },
      "Backups": [
        {
          "Name": "GitHub",
          "Path": "/Users/thomas/GitHub",
          "Count": {
            "Files": 11477,
            "Bytes": 1267144601
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cffe8ca6-65eb-4d33-83b5-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/GitHub",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751561569,
              "Ended": 1751561569,
              "Finished": true,
              "Total": {
                "Files": 11387,
                "Bytes": 1267091647
              }
            }
          ],
          "LastUpdateMS": 1751696115663,
          "LastScanStartedMS": 1751696115663,
          "NextBackupMS": 1751699715663
        },
        {
          "Name": "DxO PhotoLab v8",
          "Path": "/Users/thomas/Library/DxO PhotoLab v8",
          "Count": {
            "Files": 41,
            "Bytes": 121875995
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cffe8ca6-65eb-4d33-83b5-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/Library/DxO PhotoLab v8",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751561569,
              "Ended": 1751561569,
              "Finished": true,
              "Total": {
                "Files": 41,
                "Bytes": 120005515
              }
            }
          ],
          "LastUpdateMS": 1751696115645,
          "LastScanStartedMS": 1751696115645,
          "NextBackupMS": 1751699715645
        }
      ],
      "Sync": {
        "Count": {},
        "RemoteCount": {}
      },
      "State": {
        "RestoreWorking": true,
        "Uploading": {},
        "Downloading": {},
        "LastTokenRefresh": 1751695563
      }
    }
    """
}
