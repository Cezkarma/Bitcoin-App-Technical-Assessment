//
//  HomeViewModelTests.swift
//  Bitcoin-AppTests
//
//  Created by Joshua Coetzer on 2024/09/22.
//

import XCTest

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    fileprivate var mockNetworkService: MockNetworkService!
    fileprivate var mockKeychainAccess: MockKeychainAccess!
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
        mockNetworkService = MockNetworkService()
        mockKeychainAccess = MockKeychainAccess()
        
        NetworkService.shared = mockNetworkService
        KeychainAccess.shared = mockKeychainAccess
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockKeychainAccess = nil
        super.tearDown()
    }

    // Test fetching currency rates successfully
    func testGetFluctuationRatesSuccess() {
        let currencyRate = CurrencyRate(change: -1.0, changePct: -0.1, endRate: 5.0, startRate: 5.1)
        let expectedRates = ["USD": currencyRate]
        mockNetworkService.result = .success(FluctuationModel(base: "BTC", endDate: "2024-09-22", fluctuation: true, rates: expectedRates, startDate: "2024-09-21", success: true))
        
        viewModel.getFluctuationRates()
        
        XCTAssertEqual(viewModel.currencyRates?.count, 1)
        XCTAssertEqual(viewModel.currencyRates?["USD"]?.endRate, 5.0)
    }
    
    // Test fetching currency rates failure
    func testGetFluctuationRatesFailure() {
        mockNetworkService.result = .failure(NetworkError.noData)
        
        var alertTriggered = false
        viewModel.showFailedToGetRatesAlert = {
            alertTriggered = true
        }
        
        viewModel.getFluctuationRates()
        
        XCTAssertTrue(alertTriggered)
        XCTAssertNil(viewModel.currencyRates)
    }
    
    // Test favorite currencies changed
    func testDidFavoriteCurrenciesChangeTrue() {
        let currencyRate = CurrencyRate(change: -1.0, changePct: -0.1, endRate: 5.0, startRate: 5.1)
        let expectedRates = ["USD": currencyRate]
        mockKeychainAccess.favoriteCurrencies = ["USD", "EUR"]
        viewModel.currencyRates = expectedRates
        
        let didChange = viewModel.didFavoriteCurrenciesChange()
        
        XCTAssertTrue(didChange)
    }
    
    // Test favorite currencies not changed
    func testDidFavoriteCurrenciesChangeFalse() {
        let currencyRate = CurrencyRate(change: -1.0, changePct: -0.1, endRate: 5.0, startRate: 5.1)
        let expectedRates = ["USD": currencyRate]
        mockKeychainAccess.favoriteCurrencies = ["USD"]
        viewModel.currencyRates = expectedRates
        
        let didChange = viewModel.didFavoriteCurrenciesChange()
        
        XCTAssertFalse(didChange)
    }
}

fileprivate class MockNetworkService: NetworkService {
    var result: Result<FluctuationModel, Error>?
    
    override func fetchFluctuationRates(baseCurrency base: String, convertedCurrencies symbols: String, completion: @escaping (Result<FluctuationModel, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

fileprivate class MockKeychainAccess: KeychainAccess {
    var favoriteCurrencies: [String] = []
    
    override func retrieveFavoriteCurrencies() -> [String] {
        return favoriteCurrencies
    }
}
