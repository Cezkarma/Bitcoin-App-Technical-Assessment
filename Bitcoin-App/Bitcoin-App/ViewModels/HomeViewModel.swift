//
//  HomeViewModel.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/19.
//

import Foundation

/// A view model for managing and retrieving currency fluctuation rates.
///
/// This class is responsible for fetching fluctuation rates of the user's favorite currencies based on Bitcoin.
/// It provides functionality to check if the user's favorite currencies have changed
/// and alerts the user if there is a failure in retrieving rates from the API.
class HomeViewModel {
    
    /// A closure that is passed in from the HomeViewController that is called when there is a failure to fetch currency rates.
    var showFailedToGetRatesAlert: (() -> Void)?
    
    /// A dictionary that stores the fetched currency rates, mapped by currency code.
    var currencyRates: [String: CurrencyRate]?
    
    /// Retrieves fluctuation rates for a base currency and updates the currency rates.
    ///
    /// This method fetches fluctuation rates from the API for the base currency
    /// "BTC" and a list of the user's favorite currencies. It updates the `currencyRates` property
    /// with the fetched data or triggers an alert if the fetch fails.
    func getFluctuationRates() {
        NetworkService.shared.fetchFluctuationRates(baseCurrency: "BTC", convertedCurrencies: getFavoriteCurrenciesListAsString()) { result in
            switch result {
            case .success(let response):
                self.currencyRates = response.rates
                print("Base currency: \(response.base)")
                print("Rates: \(response.rates)")
            case .failure(let error):
                DispatchQueue.main.async {
                    (self.showFailedToGetRatesAlert ?? {})()
                }
                print("Error fetching currency rates: \(error)")
            }
        }
    }
    
    /// Returns a comma-separated string of favorite currencies.
    ///
    /// - Returns: A string representation of the user's favorite currencies retrieved from the Keychain.
    private func getFavoriteCurrenciesListAsString() -> String {
        return KeychainAccess.shared.retrieveFavoriteCurrencies().joined(separator: ",")
    }
    
    /// Checks if the favorite currencies have changed compared to the above currency rates.
    ///
    /// - Returns: A boolean indicating whether the user's favorite currencies have changed.
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
