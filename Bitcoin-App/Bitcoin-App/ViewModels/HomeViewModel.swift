//
//  HomeViewModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/19.
//

import Foundation

class HomeViewModel {
    
    var showFailedToGetRatesAlert: (() -> Void)?
    
    var currencyRates: [String: CurrencyRate]?//[(String, CurrencyRate)]
    
    func getFluctuationRates() {
        NetworkService.shared.fetchFluctuationRates(baseCurrency: "BTC", convertedCurrencies: getFavoriteCurrenciesListAsString()) { result in
            switch result {
            case .success(let response):
                self.currencyRates = response.rates
                print("Base currency: \(response.base)")
                print("Rates: \(response.rates)")
            case .failure(let error):
                (self.showFailedToGetRatesAlert ?? {})()
                print("Error fetching currency rates: \(error)")
            }
        }
    }
    
    private func getFavoriteCurrenciesListAsString() -> String {
        return KeychainAccess.shared.retrieveFavoriteCurrencies().joined(separator: ",")
    }
    
    func didFavoriteCurrenciesChange() -> Bool {
        let favoriteCurrencies = KeychainAccess.shared.retrieveFavoriteCurrencies()
        
        if currencyRates?.count != favoriteCurrencies.count { return true }
        
        guard let currencies = currencyRates?.keys else { return true }
        for currency in currencies {
            if favoriteCurrencies.contains(currency) == false {
                return true
            }
        }
        
        return false
    }
    
}
