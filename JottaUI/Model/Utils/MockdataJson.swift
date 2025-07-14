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
        "Hostname": "mac.lan",
        "AccountInfo": {
          "Capacity": 1000000000000,
          "Usage": 427131812696,
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
            "Bytes": 52066070
          },
          "Uploading": {
            "Files": 3,
            "Bytes": 15519744
          },
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
              "Started": 1751527729,
              "Ended": 1751527729,
              "Finished": true,
              "Total": {
                "Files": 25,
                "Bytes": 55464702
              }
            }
          ],
          "LastUpdateMS": 1752403319722,
          "LastScanStartedMS": 1752403319722,
          "NextBackupMS": 1752406919722
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
          "WaitingForScan": true,
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Affinity",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751531389,
              "Ended": 1751531389,
              "Finished": true,
              "Total": {
                "Files": 916,
                "Bytes": 56913325447
              }
            }
          ],
          "LastUpdateMS": 1752403317412,
          "LastScanStartedMS": 1752403317412,
          "NextBackupMS": 1752406917412
        },
        {
          "Name": "GitDocuments",
          "Path": "/Volumes/MacMini4/GitDocuments",
          "Count": {
            "Files": 1557,
            "Bytes": 723592682
          },
          "Uploading": {},
          "Errors": {},
          "WaitingForScan": true,
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/GitDocuments",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751533904,
              "Ended": 1751533904,
              "Finished": true,
              "Total": {
                "Files": 1557,
                "Bytes": 723592682
              }
            }
          ],
          "LastUpdateMS": 1752403367859,
          "LastScanStartedMS": 1752403367859,
          "NextBackupMS": 1752406967859
        },
        {
          "Name": "GitHub",
          "Path": "/Volumes/MacMini4/GitHub",
          "Count": {
            "Files": 11624,
            "Bytes": 1226277660
          },
          "Uploading": {
            "Files": 220,
            "Bytes": 7680058
          },
          "Errors": {},
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/GitHub",
              "Upload": {
                "Started": {
                  "Files": 42,
                  "Bytes": 724460
                },
                "Completed": {
                  "Files": 42,
                  "Bytes": 724460
                }
              },
              "Started": 1751527728,
              "Ended": 1751527729,
              "Finished": true,
              "Total": {
                "Files": 11664,
                "Bytes": 1168281691
              }
            }
          ],
          "LastUpdateMS": 1752403317877,
          "LastScanStartedMS": 1752403317877,
          "NextBackupMS": 1752406917877
        },
        {
          "Name": "Movies",
          "Path": "/Volumes/MacMini4/Movies",
          "Count": {
            "Files": 317,
            "Bytes": 91625462698
          },
          "Uploading": {
            "Files": 6,
            "Bytes": 12954069622
          },
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
              "Started": 1751527728,
              "Ended": 1751527728,
              "Finished": true,
              "Total": {
                "Files": 337,
                "Bytes": 101723929075
              }
            }
          ],
          "LastUpdateMS": 1752403317823,
          "LastScanStartedMS": 1752403317823,
          "NextBackupMS": 1752406917823
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
          "WaitingForScan": true,
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_jpg",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751533903,
              "Ended": 1751533903,
              "Finished": true,
              "Total": {
                "Files": 2311,
                "Bytes": 4142705596
              }
            }
          ],
          "LastUpdateMS": 1752403367987,
          "LastScanStartedMS": 1752403367987,
          "NextBackupMS": 1752406967987
        },
        {
          "Name": "Pictures_raw",
          "Path": "/Volumes/MacMini4/Pictures_raw",
          "Count": {
            "Files": 8469,
            "Bytes": 156306661853
          },
          "Uploading": {},
          "Errors": {},
          "WaitingForScan": true,
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_raw",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751531388,
              "Ended": 1751531388,
              "Finished": true,
              "Total": {
                "Files": 8268,
                "Bytes": 152679797993
              }
            }
          ],
          "LastUpdateMS": 1752403317589,
          "LastScanStartedMS": 1752403317589,
          "NextBackupMS": 1752406917589
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
          "WaitingForScan": true,
          "DeviceID": "9b62d6a0-e8b5-449a-9125-e6a3d3dc5d4d",
          "ErrorFilesCount": {},
          "History": [
            {
              "Path": "/Volumes/MacMini4/Pictures_raw_2004_2020",
              "Upload": {
                "Started": {},
                "Completed": {}
              },
              "Started": 1751533903,
              "Ended": 1751533903,
              "Finished": true,
              "Total": {
                "Files": 3870,
                "Bytes": 82365564649
              }
            }
          ],
          "LastUpdateMS": 1752403367915,
          "LastScanStartedMS": 1752403367915,
          "NextBackupMS": 1752406967915
        }
      ],
      "Sync": {
        "Count": {},
        "RemoteCount": {}
      },
      "State": {
        "BackupWorking": true,
        "RestoreWorking": true,
        "Uploading": {},
        "Downloading": {},
        "LastTokenRefresh": 1752401317
      }
    }
    """
}
