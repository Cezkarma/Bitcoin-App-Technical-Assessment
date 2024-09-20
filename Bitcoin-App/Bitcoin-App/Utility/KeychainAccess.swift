//
//  BitcoinStorer.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

//I am using a custom class to store data with Keychain, as it is more secure than using UserDefaults
class KeychainAccess {
    private let bitcoinAmountKey = "com.bitcoinApp.bitcoinAmount"
    private let apiKeyKey = "com.bitcoinApp.apiKey"
    private let favoriteCurrenciesKey = "com.bitcoinApp.favoriteCurrenciesKey"
    
    static let shared = KeychainAccess()
    
    func checkDefaults() {
        ensureAPIKeyStored()
        
        //If it's the first time loading the app, set default favourite currencies
        //Doing it like this to avoid using false checks with '!' for clean coding principles
        if UserDefaults.standard.bool(forKey: "initialLoadDone") { return }
        
        storeFavoriteCurrencies(["ZAR", "USD", "AUD"])
        UserDefaults.standard.set(true, forKey: "initialLoadDone")
    }
    
    func storeBitcoinAmount(_ amount: Double) {
        if let data = try? JSONEncoder().encode(amount) {
            save(key: bitcoinAmountKey, data: data)
        }
    }
    
    func retrieveBitcoinAmount() -> Double? {
        if let data = load(key: bitcoinAmountKey),
           let amount = try? JSONDecoder().decode(Double.self, from: data) {
            return amount
        }
        return nil
    }
    
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
    
    func storeAPIKey(_ apiKey: String) {
        if let data = apiKey.data(using: .utf8) {
            save(key: apiKeyKey, data: data)
        }
    }
    
    func retrieveAPIKey() -> String? {
        if let data = load(key: apiKeyKey),
           let apiKey = String(data: data, encoding: .utf8) {
            return apiKey
        }
        return nil
    }
    
    func addCurrency(_ currencyCode: String) {
        var favoriteCurrencies = retrieveFavoriteCurrencies()
        
        //Ensure no duplicates are added
        if !favoriteCurrencies.contains(currencyCode) {
            favoriteCurrencies.append(currencyCode)
            storeFavoriteCurrencies(favoriteCurrencies)
        }
    }
    
    func removeCurrency(_ currencyCode: String) {
        var favoriteCurrencies = retrieveFavoriteCurrencies()
        
        //Remove the currency if it exists
        if let index = favoriteCurrencies.firstIndex(of: currencyCode) {
            favoriteCurrencies.remove(at: index)
            storeFavoriteCurrencies(favoriteCurrencies)
        }
    }
    
    func retrieveFavoriteCurrencies() -> [String] {
        if let data = load(key: favoriteCurrenciesKey),
           let favoriteCurrencies = try? JSONDecoder().decode([String].self, from: data) {
            return favoriteCurrencies
        }
        return []
    }
    
    private func storeFavoriteCurrencies(_ favoriteCurrencies: [String]) {
        if let data = try? JSONEncoder().encode(favoriteCurrencies) {
            save(key: favoriteCurrenciesKey, data: data)
        }
    }
    
    private func save(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
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
