//
//  BitcoinStorer.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

//I am using a custom class to store data with Keychain, as it is more secure than using UserDefaults
class KeychainAccess {
    let bitcoinAmountKey = "com.yourApp.bitcoinAmount"
    
    static let shared = KeychainAccess()
    
    func storeBitcoinAmount(_ amount: Double) {
            //Convert the amount to String for Keychain storage
            let amountString = String(amount)
            guard let amountData = amountString.data(using: .utf8) else { return }
            
            //Create a query to store the value in Keychain
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: bitcoinAmountKey,
                kSecValueData as String: amountData
            ]
            
            //Add to Keychain
            SecItemDelete(query as CFDictionary) // Delete any existing item
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                print("Bitcoin amount successfully saved in Keychain.")
            } else {
                print("Error saving Bitcoin amount to Keychain: \(status)")
            }
        }
        
        func retrieveBitcoinAmount() -> Double? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: bitcoinAmountKey,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess, let data = item as? Data, let amountString = String(data: data, encoding: .utf8), let amount = Double(amountString) {
                return amount
            } else {
                print("Error retrieving Bitcoin amount from Keychain: \(status)")
                return nil
            }
        }
}
