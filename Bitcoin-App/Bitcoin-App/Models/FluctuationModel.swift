//
//  FluctuationModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

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
}
