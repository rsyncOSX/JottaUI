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
        "Email": "thomas@mail",
        "Fullname": "Thomas",
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
          "Usage": 416746269295,
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
          "Name": "GitDocuments",
          "Path": "/Users/thomas/GitDocuments",
          "Count": {
            "Files": 1302,
            "Bytes": 716710613
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cccccccc-eeee-dddd-8888-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/GitDocuments",
              "Upload": {
                "Started": {
                  "Files": 1302,
                  "Bytes": 716710613
                },
                "Completed": {
                  "Files": 1302,
                  "Bytes": 716710613
                }
              },
              "Started": 1751988022,
              "Ended": 1751988103,
              "Finished": true,
              "Total": {
                "Files": 1302,
                "Bytes": 716710613
              }
            }
          ],
          "LastUpdateMS": 1751988841597,
          "LastScanStartedMS": 1751988841597,
          "NextBackupMS": 1751992441597
        },
        {
          "Name": "GitHub",
          "Path": "/Users/thomas/GitHub",
          "Count": {
            "Files": 11073,
            "Bytes": 1266382867
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cccccccc-eeee-dddd-8888-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/GitHub",
              "Upload": {
                "Started": {
                  "Files": 41,
                  "Bytes": 958804
                },
                "Completed": {
                  "Files": 41,
                  "Bytes": 958804
                }
              },
              "Started": 1751863962,
              "Ended": 1751863964,
              "Finished": true,
              "Total": {
                "Files": 10978,
                "Bytes": 1266296439
              }
            }
          ],
          "LastUpdateMS": 1751988841701,
          "LastScanStartedMS": 1751988841701,
          "NextBackupMS": 1751992441701
        },
        {
          "Name": "DxO PhotoLab v8",
          "Path": "/Users/thomas/Library/DxO PhotoLab v8",
          "Count": {
            "Files": 41,
            "Bytes": 122030627
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cccccccc-eeee-dddd-8888-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/Library/DxO PhotoLab v8",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751863962,
              "Ended": 1751863962,
              "Finished": true,
              "Total": {
                "Files": 41,
                "Bytes": 122445747
              }
            }
          ],
          "LastUpdateMS": 1751988841579,
          "LastScanStartedMS": 1751988841579,
          "NextBackupMS": 1751992441579
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
        "LastTokenRefresh": 1751988250
      }
    }
    """
}
