//
//  FavoritesViewModelTests.swift
//  Bitcoin-AppTests
//
//  Created by Joshua Coetzer on 2024/09/22.
//

import XCTest

final class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    fileprivate var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        viewModel = FavoritesViewModel()
        mockNetworkService = MockNetworkService()
        
        NetworkService.shared = mockNetworkService
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    //Test fetching currency symbols successfully
    func testGetCurrencySymbolsSuccess() {
        let expectedSymbols = CurrencySymbolsModel(success: true, symbols: ["EUR":"Euro","USD":"US Dollar"])
        mockNetworkService.result = .success(expectedSymbols)
        
        viewModel.getCurrencySymbols()
        
        XCTAssertEqual(viewModel.symbols.count, 2)
        XCTAssertTrue(viewModel.symbols.contains("EUR"))
        XCTAssertTrue(viewModel.symbols.contains("USD"))
        XCTAssertFalse(viewModel.symbols.contains("BTC"))
        XCTAssertEqual(viewModel.symbols, ["EUR", "USD"]) //Check if sorted
    }
    
    //Test fetching currency symbols failure
    func testGetCurrencySymbolsFailure() {
        mockNetworkService.result = .failure(NetworkError.noData)
        
        var alertTriggered = false
        viewModel.showFailedToGetSymbolsAlert = {
            alertTriggered = true
        }
        
        viewModel.getCurrencySymbols()
        
        XCTAssertTrue(alertTriggered)
        XCTAssertTrue(viewModel.symbols.isEmpty) //Symbols should not be updated on failure
    }
    
}

fileprivate class MockNetworkService: NetworkService {
    var result: Result<CurrencySymbolsModel, Error>?
    
    override func fetchSymbols(completion: @escaping (Result<CurrencySymbolsModel, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}
