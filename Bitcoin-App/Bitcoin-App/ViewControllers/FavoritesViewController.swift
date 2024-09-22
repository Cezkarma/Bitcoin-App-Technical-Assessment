//
//  FavoritesViewController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

/// The view controller responsible for displaying and managing the user's favorite currencies.
///
/// `FavoritesViewController` allows users to view a list of available currencies and select their favorites.
/// These favorites are stored in the Keychain for persistence, and the view controller updates the UI
/// to reflect changes in the favorite status of each currency.
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let viewModel: FavoritesViewModel
    
    /// Called after the view has been loaded into memory.
    ///
    /// This method registers the custom cell used in the table view, sets the data source, and triggers
    /// the fetching of currency symbols via the view model. It also sends a closure to its view model to handle
    /// the event of a failure to fetch symbols from the API.
    override func viewDidLoad() {
        favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
        favoritesTableView.dataSource = self
        
        viewModel.showFailedToGetSymbolsAlert = showFailedToGetRatesAlert
        viewModel.getCurrencySymbols()
    }
    
    init() {
        viewModel = FavoritesViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Displays an alert if the app fails to retrieve currency symbols from the API.
    private func showFailedToGetRatesAlert() {
        let alert = UIAlertController(title: "Failed to get symbols", message: "Please try again later.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            print("OK tapped")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - FavoritesTableViewCellDelegate

/// Conformance to the custom delegate protocol, in accordance with the delegate pattern, for handling favorite button actions in the cell.
extension FavoritesViewController: FavoritesTableViewCellDelegate {
    
    /// Handles the event when the user taps the favorite button on a cell.
    ///
    /// This method updates the favorite status of the currency represented by the cell by adding or removing it from the Keychain.
    /// It also toggles the button's selected state to reflect the change.
    ///
    /// - Parameter cell: The table view cell that contains the tapped favorite button.
    func didTapFavoriteButton(on cell: FavoritesTableViewCell) {
        if cell.favoriteButton.isSelected {
            KeychainAccess.shared.removeCurrency(cell.currencyCodeLabel.text ?? "")
        } else {
            KeychainAccess.shared.addCurrency(cell.currencyCodeLabel.text ?? "")
        }
        
        cell.favoriteButton.isSelected.toggle()
    }
}

// MARK: - UITableViewDataSource

/// Conformance to the table view data source protocol for populating the table view with currency data.
///
/// Adding the UITableView related conformance here for clean coding purposes.
extension FavoritesViewController: UITableViewDataSource {
    
    /// Returns the number of rows (currency symbols) to display in the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.symbols.count
    }
    
    /// Configures and returns the cell for the row at the given index path.
    ///
    /// This method populates each table view cell with a currency symbol and configures the favorite button's state.
    /// It also assigns the view controller as the delegate for handling the favorite button's clicks.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let symbol: String = viewModel.symbols[indexPath.row]
        cell.currencyCodeLabel.text = symbol
        cell.favoriteButton.isSelected = KeychainAccess.shared.retrieveFavoriteCurrencies().contains(symbol)
        cell.delegate = self
        
        return cell
    }
}
