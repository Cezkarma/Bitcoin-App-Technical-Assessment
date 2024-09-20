//
//  NetworkService.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private let baseUrl = "https://api.apilayer.com/fixer/"
    
    private init() {}
    
    func fetchFluctuationRates(baseCurrency base: String, convertedCurrencies symbols: String, completion: @escaping (Result<FluctuationModel, Error>) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let yesterday = Date.yesterdayAsString()
        let today = Date.todayAsString()
        let urlString = baseUrl+"fluctuation?symbols=\(symbols)&base=\(base)&start_date=\(yesterday)&end_date=\(today)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
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
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
