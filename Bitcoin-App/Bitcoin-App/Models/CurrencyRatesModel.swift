//
//  CurrencyRatesModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

struct CurrencyRatesModel: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
    let success: Bool
    let timestamp: Int
}
