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
    
    public func GetFluctuationRates() {
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
    
    public func GetConvertedCurrencies() {
        NetworkService.shared.fetchCurrencyRates(baseCurrency: "BTC", convertedCurrencies: getFavoriteCurrenciesListAsString()) { result in
            switch result {
            case .success(let response):
                print("Base currency: \(response.base)")
                print("Date: \(response.date)")
                print("Rates: \(response.rates)")
                print("Timestamp: \(response.timestamp)")
            case .failure(let error):
                print("Error fetching currency rates: \(error)")
            }
        }
    }
    
    private func getFavoriteCurrenciesListAsString() -> String {
        return KeychainAccess.shared.retrieveFavoriteCurrencies().joined(separator: ",")
    }
    
}
