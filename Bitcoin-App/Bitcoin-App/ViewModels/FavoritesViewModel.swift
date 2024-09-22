//
//  FavoritesViewModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation

class FavoritesViewModel {
    
    var showFailedToGetSymbolsAlert: (() -> Void)?
    
    var symbols: [String] = []
    
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
                (self.showFailedToGetSymbolsAlert ?? {})()
                print("Error fetching currency rates: \(error)")
            }
        }
    }
    
}
