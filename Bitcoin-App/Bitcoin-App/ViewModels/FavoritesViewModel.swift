//
//  FavoritesViewModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation

/// A view model for managing and retrieving currency symbols.
///
/// This class handles the fetching of available currency symbols. It provides functionality
/// to alert the user in case of a failure during the retrieval of symbols from the API.
class FavoritesViewModel {
    
    /// A closure that is passed in from the FavoritesViewController that is called when there is a failure to fetch the currency symbols.
    var showFailedToGetSymbolsAlert: (() -> Void)?
    
    /// An array that stores the retrieved currency symbols, excluding the base currency "BTC".
    ///
    /// "BTC" is excluded because the user shouldn't be able to add/remove it from their favorites since this is a Bitcoin app.
    var symbols: [String] = []
    
    /// Fetches available currency symbols from the network service.
    ///
    /// This method retrieves currency symbols from the API and populates the
    /// `symbols` array with the keys from the response, excluding "BTC". The symbols
    /// are then sorted alphabetically.
    public func getCurrencySymbols() {
        NetworkService.shared.fetchSymbols() { result in
            switch result {
            case .success(let response):
                for s in response.symbols {
                    if s.key != "BTC" {
                        self.symbols.append(s.key)
                    }
                }
                self.symbols.sort()
            case .failure(let error):
                DispatchQueue.main.async {
                    (self.showFailedToGetSymbolsAlert ?? {})()
                }
                print("Error fetching currency rates: \(error)")
            }
        }
    }
}
