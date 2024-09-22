//
//  FluctuationModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

/// A model representing the fluctuation rates of different currencies based on a base currency.
///
/// This struct conforms to the `Codable` protocol and is used to parse and encode
/// fluctuation rate data received from the API. It contains information about the
/// base currency, date range, and fluctuation rates of other currencies against the base currency.
struct FluctuationModel: Codable {
    let base: String
    let endDate: String
    let fluctuation: Bool
    let rates: [String: CurrencyRate]
    let startDate: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case base
        case endDate = "end_date"
        case fluctuation
        case rates
        case startDate = "start_date"
        case success
    }
}

/// A model representing the rate changes for a specific currency.
///
/// This struct conforms to the `Codable` protocol and is used to parse and encode
/// currency rate change data. It includes information about the change amount,
/// percentage change, and the starting and ending rates.
struct CurrencyRate: Codable {
    let change: Double
    let changePct: Double
    let endRate: Double
    let startRate: Double
    
    enum CodingKeys: String, CodingKey {
        case change
        case changePct = "change_pct"
        case endRate = "end_rate"
        case startRate = "start_rate"
    }
    
    /// Initializes a new `CurrencyRate` instance with the specified values.
    ///
    /// - Parameters:
    ///   - change: The absolute change in the currency rate.
    ///   - changePct: The percentage change in the currency rate.
    ///   - endRate: The ending rate of the currency.
    ///   - startRate: The starting rate of the currency.
    public init(change: Double, changePct: Double, endRate: Double, startRate: Double) {
        self.change = change
        self.changePct = changePct
        self.endRate = endRate
        self.startRate = startRate
    }
}
