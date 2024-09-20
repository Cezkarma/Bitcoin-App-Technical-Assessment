//
//  Date+StringDates.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

extension Date {
    private func formattedAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    static func yesterdayAsString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return yesterday.formattedAsString()
    }

    static func todayAsString() -> String {
        return Date().formattedAsString()
    }
}
