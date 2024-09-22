//
//  BitcoinStorer.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

/// A class that grants convenience functions for storing data in the Keychain.
///
/// - Note: I am using a custom class to store data with the Keychain, as it is more secure than using UserDefaults.
class KeychainAccess {
    
    /// Strings that act as keys for storing and retrieving specific data from the Keychain
    private let bitcoinAmountKey = "com.bitcoinApp.bitcoinAmount"
    private let apiKeyKey = "com.bitcoinApp.apiKey"
    private let favoriteCurrenciesKey = "com.bitcoinApp.favoriteCurrenciesKey"
    
    /// This variable is used to access the singleton instance of the class
    ///
    /// Made this a variable instead of a constant so that the unit tests can set it to the mocks
    static var shared = KeychainAccess()
    
    /// Checks that the API key is stored, and sets the default currencies if it's the first time loading the app.
    ///
    /// - Note: Uses UserDefaults for checking if this is the initial load of the app, since that's the more appropriate way to store that kind of information.
    func checkDefaults() {
        ensureAPIKeyStored()
        
        /// If it's the first time loading the app, set default favourite currencies
        if UserDefaults.standard.bool(forKey: "initialLoadDone") { return }
        
        /// Store the default currencies and set the app as having done its initial load.
        storeFavoriteCurrencies(["ZAR", "USD", "AUD"])
        UserDefaults.standard.set(true, forKey: "initialLoadDone")
    }
    
    /// Stores a specified amount of Bitcoin.
    ///
    /// - Parameter amount: The amount of Bitcoin the user owns.
    func storeBitcoinAmount(_ amount: Double) {
        if let data = try? JSONEncoder().encode(amount) {
            save(key: bitcoinAmountKey, data: data)
        }
    }
    
    /// Retrieves the amount of Bitcoin the user owns.
    ///
    /// - Returns: The user's total Bitcoin as a `Double`.
    func retrieveBitcoinAmount() -> Double? {
        if let data = load(key: bitcoinAmountKey),
           let amount = try? JSONDecoder().decode(Double.self, from: data) {
            return amount
        }
        return nil
    }
    
    /// Makes sure that the app has an API key stored to use for API calls.
    ///
    ///  - Note: If the new API key below is different to the one currently stored, it replaces the old one with the new one.
    ///  - Note: The newApiKey below might be outdated. If it is, please reach out to me to get a new one.
    private func ensureAPIKeyStored() {
        let newApiKey = "phyJY3eNe3YosVD66GT5uazEvazjvuzt"
        
        if let currentApiKey = retrieveAPIKey() {
            if currentApiKey != newApiKey {
                storeAPIKey(newApiKey)
                print("New API key stored.")
                return
            }
            print("API Key already stored.")
        } else {
            storeAPIKey(newApiKey)
            print("API Key stored in Keychain.")
        }
    }
    
    /// Stores the API key.
    ///
    /// - Parameter apiKey: The API key to be stored.
    private func storeAPIKey(_ apiKey: String) {
        if let data = apiKey.data(using: .utf8) {
            save(key: apiKeyKey, data: data)
        }
    }
    
    /// Retrieves the API key.
    ///
    /// - Returns: The currently stored API key as a `String`.
    func retrieveAPIKey() -> String? {
        if let data = load(key: apiKeyKey),
           let apiKey = String(data: data, encoding: .utf8) {
            return apiKey
        }
        return nil
    }
    
    /// Adds a currency code to the user's Favorited currencies.
    ///
    /// - Parameter currencyCode: The currency to be stored as its three-letter code.
    func addCurrency(_ currencyCode: String) {
        var favoriteCurrencies = retrieveFavoriteCurrencies()
        
        //Ensure no duplicates are added
        if !favoriteCurrencies.contains(currencyCode) {
            favoriteCurrencies.append(currencyCode)
            storeFavoriteCurrencies(favoriteCurrencies)
        }
    }
    
    /// Removes a currency code from the user's Favorited currencies.
    ///
    /// - Parameter currencyCode: The currency to be stored as its three-letter code.
    func removeCurrency(_ currencyCode: String) {
        var favoriteCurrencies = retrieveFavoriteCurrencies()
        
        //Remove the currency if it exists
        if let index = favoriteCurrencies.firstIndex(of: currencyCode) {
            favoriteCurrencies.remove(at: index)
            storeFavoriteCurrencies(favoriteCurrencies)
        }
    }
    
    /// Retrieves the user's favorite currencies.
    ///
    /// - Returns: The user's favorite currencies as a `[String]`.
    func retrieveFavoriteCurrencies() -> [String] {
        if let data = load(key: favoriteCurrenciesKey),
           let favoriteCurrencies = try? JSONDecoder().decode([String].self, from: data) {
            return favoriteCurrencies
        }
        return []
    }
    
    /// Stores the list of the user's favorite currencies in the Keychain.
    ///
    /// - Parameter favoriteCurrencies: And array of the user's favorite currencies as three-letter codes.
    private func storeFavoriteCurrencies(_ favoriteCurrencies: [String]) {
        if let data = try? JSONEncoder().encode(favoriteCurrencies) {
            save(key: favoriteCurrenciesKey, data: data)
        }
    }
    
    /// Saves data to the Keychain.
    ///
    /// - Parameters:
    ///  - key: The key specifying where the data should be saved to.
    ///  - data: The data being saved.
    private func save(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Loads data from the Keychain.
    ///
    /// - Parameter key: The key specifying where the data should be loaded from.
    /// - Returns: The data retrieved from the Keychain.
    private func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
}
