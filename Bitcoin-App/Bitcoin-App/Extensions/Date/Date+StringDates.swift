//
//  Date+StringDates.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

/// A `Date` extension that provides convenience functions for getting today and yesterday's date as `Strings`.
extension Date {
    
    /// Turns a `Date` instance into a `String` in the yyyy-MM-dd format.
    ///
    /// - Returns: The date as a String.
    ///
    /// - Note: This function was created to get the date in a certain format in order to send it to fluctuation endpoint.
    private func formattedAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    /// Returns yesterday's date as a `String` in the yyyy-MM-dd format.
    ///
    /// - Returns: Yesterday's date as a `String`.
    ///
    /// - Note: It gets yesterday's date by subtracting 1 day from the current date.
    static func yesterdayAsString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return yesterday.formattedAsString()
    }

    /// Returns today's date as a `String` in the yyyy-MM-dd format.
    ///
    /// - Returns: Today's date as a `String`.
    static func todayAsString() -> String {
        return Date().formattedAsString()
    }
}
