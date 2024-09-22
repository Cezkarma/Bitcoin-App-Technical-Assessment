//
//  CurrencySymbolsModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation

struct CurrencySymbolsModel: Codable {
    let success: Bool
    let symbols: [String: String]
}
