//
//  FavoritesViewController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private let viewModel: FavoritesViewModel
    
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
    
    private func showFailedToGetRatesAlert() {
        let alert = UIAlertController(title: "Failed to get symbols", message: "Please try again later.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            print("OK tapped")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension FavoritesViewController: FavoritesTableViewCellDelegate {
    func didTapFavoriteButton(on cell: FavoritesTableViewCell) {
        if cell.favoriteButton.isSelected {
            KeychainAccess.shared.removeCurrency(cell.currencyCodeLabel.text ?? "")
        } else {
            KeychainAccess.shared.addCurrency(cell.currencyCodeLabel.text ?? "")
        }
        cell.favoriteButton.isSelected.toggle()
        print(KeychainAccess.shared.retrieveFavoriteCurrencies())
        //favoritesTableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.symbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let symbol: String = viewModel.symbols[indexPath.row]
        cell.currencyCodeLabel.text = symbol
        cell.favoriteButton.isSelected = KeychainAccess.shared.retrieveFavoriteCurrencies().contains(symbol)
        cell.delegate = self
            
        return cell
    }
}
