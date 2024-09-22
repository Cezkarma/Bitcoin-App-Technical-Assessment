//
//  CurrencySymbolsModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation

/// A model representing the available currency symbols.
///
/// This struct conforms to the `Codable` protocol and is used to parse and encode
/// data related to currency symbols received from the API. It contains a success flag
/// and a dictionary of currency symbols mapped to their respective codes.
struct CurrencySymbolsModel: Codable {
    let success: Bool
    let symbols: [String: String]
    
    /// Initializes a new `CurrencySymbolsModel` instance with the specified values.
    ///
    /// - Parameters:
    ///   - success: A boolean indicating whether the retrieval of symbols was successful.
    ///   - symbols: A dictionary mapping currency codes (as `String`) to their full names (as `String`).
    init(success: Bool, symbols: [String : String]) {
        self.success = success
        self.symbols = symbols
    }
}
