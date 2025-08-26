//
//  extstensionDate.swift
//  JottaUI
//
//  Created by Thomas Evensen on 01/07/2025.
//

//
//  extension Date
//  RsyncOSX
//
//  Created by Thomas Evensen on 08/12/2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation

extension Date {
    func string_from_date() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.string(from: self)
    }

    func localized_string_from_date() -> String {
        let dateformatter = DateFormatter()
        dateformatter.formatterBehavior = .behavior10_4
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        return dateformatter.string(from: self)
    }
}

extension String {
    func date_from_string() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.date(from: self) ?? Date()
    }
    
    func status_from_string() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        dateformatter.dateFormat = "EEE MMM dd HH:mm:ss" // Match the string format
        return dateformatter.date(from: self) ?? Date()
    }
}


/*
 /*
  import Foundation

  let dateString = "Tue Aug 26 12:52:20"
  let dateFormatter = DateFormatter()
  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
  dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss" // Match the string format

  if let date = dateFormatter.date(from: dateString) {
      print("Converted Date: \\(date)")
  } else {
      print("Failed to convert date")
  }

  */
 */
