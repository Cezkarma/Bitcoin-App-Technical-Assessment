//
//  NetworkService.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

/// A class that grants access to API calls and their response data.
class NetworkService {
    
    /// This variable is used to access the singleton instance of the class
    /// 
    /// Made this a variable instead of a constant so that the unit tests can set it to the mocks
    static var shared = NetworkService()
    
    /// The base Fixer url that I will be using throughout this class for API calls by attaching endpoints.
    private let baseUrl = "https://api.apilayer.com/fixer/"
    
    init() {}
    
    /// Fetches fluctuation rates for a given base currency and specified currencies.
    ///
    /// This function retrieves the fluctuation rates between a base currency and specified converted currencies
    /// for a defined date range (yesterday to today). It sends a GET request to the specified API endpoint
    /// and handles the response asynchronously through a completion handler.
    ///
    /// - Parameters:
    ///   - base: The base currency code as a three-letter `String` (e.g., "USD") from which fluctuations are calculated.
    ///   - symbols: A comma-separated list of converted currency codes as a `String` (e.g., "EUR,GBP") to fetch
    ///     fluctuation rates against the base currency.
    ///   - completion: A closure that is called when the data task is complete. It takes a `Result` containing
    ///     either a `FluctuationModel` on success or an `Error` on failure.
    ///
    /// - Throws: This function does not throw errors directly, but errors are passed through the completion handler.
    ///
    /// - Note: The function uses a semaphore to wait for the asynchronous network call to complete.
    func fetchFluctuationRates(baseCurrency base: String, convertedCurrencies symbols: String, completion: @escaping (Result<FluctuationModel, Error>) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let yesterday = Date.yesterdayAsString()
        let today = Date.todayAsString()
        let urlString = baseUrl+"fluctuation?symbols=\(symbols)&base=\(base)&start_date=\(yesterday)&end_date=\(today)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)//Double.infinity was recommended by the Fixer API's documentation, which is why I used it.
        request.httpMethod = "GET"
        request.addValue(KeychainAccess().retrieveAPIKey() ?? "", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response JSON: \(jsonString)")
            }
            
            do {
                let fluctuationRates = try JSONDecoder().decode(FluctuationModel.self, from: data)
                completion(.success(fluctuationRates))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        semaphore.wait()
    }
    
    /// Fetches all available currency symbols from the API.
    ///
    /// This function sends a GET request to retrieve a list of available currency symbols.
    /// It handles the response asynchronously through a completion handler, which provides
    /// either a successful `CurrencySymbolsModel` or an `Error` on failure.
    ///
    /// - Parameter completion: A closure that is called when the data task is complete.
    ///   It takes a `Result` containing either a `CurrencySymbolsModel` on success or an `Error` on failure.
    ///
    /// - Throws: This function does not throw errors directly, but errors are passed through the completion handler.
    ///
    /// - Note: The function uses a semaphore to wait for the asynchronous network call to complete.
    func fetchSymbols(completion: @escaping (Result<CurrencySymbolsModel, Error>) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let urlString = baseUrl+"symbols"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)//Double.infinity was recommended by the Fixer API's documentation, which is why I used it.
        request.httpMethod = "GET"
        request.addValue(KeychainAccess().retrieveAPIKey() ?? "", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response JSON: \(jsonString)")
            }
            
            do {
                let currencySymbols = try JSONDecoder().decode(CurrencySymbolsModel.self, from: data)
                completion(.success(currencySymbols))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        semaphore.wait()
    }
}

/// An enum to specify what kind of network error was encountered.
enum NetworkError: Error {
    case invalidURL
    case noData
}
