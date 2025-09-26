//
//  extstension.swift
//  JottaUI
//
//  Created by Thomas Evensen on 01/07/2025.
//
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

    func year() -> Int? {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year
    }
}

extension String {
    func date_from_string() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateformatter.date(from: self) ?? Date()
    }

    func status_date_from_string() -> Date? {
        let dateformatter = DateFormatter()
        // dateformatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        dateformatter.dateFormat = "yyyy EEE MMM dd HH:mm:ss" // Match the string format
        return dateformatter.date(from: self) ?? Date()
    }
}

extension Double {
    func latest() -> String {
        let seconds = self

        // Less than 1 minute (60 seconds)
        if seconds < 60 {
            let secondsValue = Int(seconds)
            return secondsValue == 1 ? "\(secondsValue) second ago" : "\(secondsValue) seconds ago"
        }
        // Less than 1 hour (3600 seconds)
        else if seconds < 3600 {
            let minutes = seconds / 60
            return (minutes < 2 ? String(format: "%.0f min", minutes) : String(format: "%.0f mins", minutes)) + " ago"
        }
        // Less than 1 day (86400 seconds)
        else if seconds < 86400 {
            let hours = seconds / 3600
            return (hours < 2 ? String(format: "%.1f hour", hours) : String(format: "%.1f hours", hours)) + " ago"
        }
        // 1 day or more
        else {
            let days = seconds / 86400
            return (days < 2 ? String(format: "%.1f day", days) : String(format: "%.1f days", days)) + " ago"
        }
    }
}
