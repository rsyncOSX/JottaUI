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
        "Hostname": "mini4.local",
        "AccountInfo": {
          "Capacity": 1000000000000,
          "Usage": 440492607691,
          "Subscription": 1,
          "CanUpgrade": true,
          "UpgradeHint": true,
          "SubscriptionNameLocalized": "Home subscription 1 TB",
          "ProductNameLocalized": "Home subscription 1 TB"
        },
        "device": {
          "Name": "macmini.lan",
          "Type": 12
        }
      },
      "Backups": [
        {
          "Name": "DxO PhotoLab v8",
          "Path": "/Users/thomas/Library/DxO PhotoLab v8",
          "Count": {
            "Files": 25,
            "Bytes": 55428214
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/Library/DxO PhotoLab v8",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751608952,
              "Ended": 1751608952,
              "Finished": true,
              "Total": {
                "Files": 25,
                "Bytes": 54663070
              }
            }
          ],
          "LastUpdateMS": 1752487033916,
          "LastScanStartedMS": 1752487033916,
          "NextBackupMS": 1752490633916
        },
        {
          "Name": "Affinity",
          "Path": "/Volumes/MacMini4/Affinity",
          "Count": {
            "Files": 920,
            "Bytes": 58068877687
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Affinity",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751608952,
              "Ended": 1751608952,
              "Finished": true,
              "Total": {
                "Files": 916,
                "Bytes": 56913325447
              }
            }
          ],
          "LastUpdateMS": 1752487033952,
          "LastScanStartedMS": 1752487033952,
          "NextBackupMS": 1752490633952
        },
        {
          "Name": "GitDocuments",
          "Path": "/Volumes/MacMini4/GitDocuments",
          "Count": {
            "Files": 1622,
            "Bytes": 740797025
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/GitDocuments",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1752403319,
              "Ended": 1752403319,
              "Finished": true,
              "Total": {
                "Files": 1557,
                "Bytes": 723592682
              }
            }
          ],
          "LastUpdateMS": 1752487033859,
          "LastScanStartedMS": 1752487033859,
          "NextBackupMS": 1752490633859
        },
        {
          "Name": "GitHub",
          "Path": "/Volumes/MacMini4/GitHub",
          "Count": {
            "Files": 11822,
            "Bytes": 1226492825
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/GitHub",
              "Upload": {
                "Started": {
                  "Files": 4,
                  "Bytes": 137343
                },
                "Completed": {
                  "Files": 4,
                  "Bytes": 137343
                }
              },
              "Started": 1751608952,
              "Ended": 1751608953,
              "Finished": true,
              "Total": {
                "Files": 11829,
                "Bytes": 1168452222
              }
            }
          ],
          "LastUpdateMS": 1752487033536,
          "LastScanStartedMS": 1752487033536,
          "NextBackupMS": 1752490633536
        },
        {
          "Name": "Movies",
          "Path": "/Volumes/MacMini4/Movies",
          "Count": {
            "Files": 317,
            "Bytes": 91625462698
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Movies",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751608952,
              "Ended": 1751608952,
              "Finished": true,
              "Total": {
                "Files": 337,
                "Bytes": 101723929075
              }
            }
          ],
          "LastUpdateMS": 1752487033493,
          "LastScanStartedMS": 1752487033493,
          "NextBackupMS": 1752490633493
        },
        {
          "Name": "Pictures_jpg",
          "Path": "/Volumes/MacMini4/Pictures_jpg",
          "Count": {
            "Files": 2311,
            "Bytes": 4142705596
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_jpg",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1752403317,
              "Ended": 1752403317,
              "Finished": true,
              "Total": {
                "Files": 2311,
                "Bytes": 4142705596
              }
            }
          ],
          "LastUpdateMS": 1752487034357,
          "LastScanStartedMS": 1752487034357,
          "NextBackupMS": 1752490634357
        },
        {
          "Name": "Pictures_raw",
          "Path": "/Volumes/MacMini4/Pictures_raw",
          "Count": {
            "Files": 8481,
            "Bytes": 156524964242
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_raw",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751608952,
              "Ended": 1751608952,
              "Finished": true,
              "Total": {
                "Files": 8292,
                "Bytes": 153167309374
              }
            }
          ],
          "LastUpdateMS": 1752487034118,
          "LastScanStartedMS": 1752487034118,
          "NextBackupMS": 1752490634118
        },
        {
          "Name": "Pictures_raw_2004_2020",
          "Path": "/Volumes/MacMini4/Pictures_raw_2004_2020",
          "Count": {
            "Files": 3870,
            "Bytes": 82365564649
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_raw_2004_2020",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1752403317,
              "Ended": 1752403317,
              "Finished": true,
              "Total": {
                "Files": 3870,
                "Bytes": 82365564649
              }
            }
          ],
          "LastUpdateMS": 1752487033977,
          "LastScanStartedMS": 1752487033977,
          "NextBackupMS": 1752490633977
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
        "LastTokenRefresh": 1752485728
      }
    }
    """
    
    let json2 = """
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
          "Usage": 440492071454,
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
            "Files": 1349,
            "Bytes": 732985094
          },
          "Uploading": {},
          "Errors": {},
          "DeviceID": "cffe8ca6-65eb-4d33-83b5-42b97e5f9dc9",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Users/thomas/GitDocuments",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1752380995,
              "Ended": 1752380995,
              "Finished": true,
              "Total": {
                "Files": 1349,
                "Bytes": 732985094
              }
            }
          ],
          "LastUpdateMS": 1752500120349,
          "LastScanStartedMS": 1752500120349,
          "NextBackupMS": 1752503720349
        },
        {
          "Name": "GitHub",
          "Path": "/Users/thomas/GitHub",
          "Count": {
            "Files": 11986,
            "Bytes": 1556527863
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
              "Started": 1752380994,
              "Ended": 1752380995,
              "Finished": true,
              "Total": {
                "Files": 11802,
                "Bytes": 1636891580
              }
            }
          ],
          "LastUpdateMS": 1752500120155,
          "LastScanStartedMS": 1752500120155,
          "NextBackupMS": 1752503720155
        },
        {
          "Name": "DxO PhotoLab v8",
          "Path": "/Users/thomas/Library/DxO PhotoLab v8",
          "Count": {
            "Files": 41,
            "Bytes": 119911195
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
              "Started": 1752380995,
              "Ended": 1752380995,
              "Finished": true,
              "Total": {
                "Files": 41,
                "Bytes": 120871587
              }
            }
          ],
          "LastUpdateMS": 1752500120330,
          "LastScanStartedMS": 1752500120330,
          "NextBackupMS": 1752503720330
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
        "LastTokenRefresh": 1752497842
      }
    }
    """
}
