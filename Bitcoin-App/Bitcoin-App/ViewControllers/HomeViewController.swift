//
//  ViewController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/19.
//

import UIKit

/// The view controller responsible for displaying and managing the home screen of the app.
///
/// `HomeViewController` provides an interface where users can input the amount of Bitcoin they own,
/// view a list of their favorite currencies, and see the current rates and trends for each currency.
/// The class handles user input, communicates with a view model to fetch fluctuation rates, and manages
/// the display of data in a table view.
class HomeViewController: UIViewController {
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    @IBOutlet weak var currenciesTableView: UITableView!
    
    private let viewModel: HomeViewModel
    
    /// Called after the view has been loaded into memory.
    ///
    /// This method sets up the UI components such as table view configuration, adds a tap gesture to dismiss the keyboard,
    /// and fetches fluctuation rates using the view model. It also sends a closure to the view model
    /// to handle the event of a failure to fetch rates.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss the keyboard when tapping outside the text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Configure table view
        currenciesTableView.rowHeight = UITableView.automaticDimension
        currenciesTableView.estimatedRowHeight = 65.0
        currenciesTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        currenciesTableView.dataSource = self
        
        // Setup alert handling and fetch initial data
        viewModel.showFailedToGetRatesAlert = showFailedToGetRatesAlert
        viewModel.getFluctuationRates()
    }
    
    /// Called before the view is displayed on screen.
    ///
    /// If the favorite currencies have changed since the last appearance,
    /// the fluctuation rates are fetched again and the table view is reloaded.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.didFavoriteCurrenciesChange() {
            viewModel.getFluctuationRates()
            currenciesTableView.reloadData()
        }
    }
    
    init() {
        viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Action triggered when the user clicks the update button.
    ///
    /// This method validates the user input for Bitcoin amount, stores it, and reloads the table view with updated data. If the input is invalid, an alert is shown.
    @IBAction func updateButtonClicked(_ sender: Any) {
        if let bitcoinAmount = Double(inputAmountTextField.text ?? "") {
            if bitcoinAmount < 0.0 {
                showInvalidAmountAlert()
            } else {
                KeychainAccess.shared.storeBitcoinAmount(bitcoinAmount)
                print(KeychainAccess.shared.retrieveBitcoinAmount() ?? 0.0)
                inputAmountTextField.text = ""
                dismissKeyboard()
                currenciesTableView.reloadData()
            }
        } else {
            showInvalidAmountAlert()
            return
        }
    }
    
    /// Shows an alert for invalid Bitcoin amount input.
    private func showInvalidAmountAlert() {
        showProblemAlert(title: "Invalid input", message: "Please make sure that you input a valid, positive decimal amount.")
    }
    
    /// Shows an alert if the app fails to retrieve fluctuation rates from the API.
    private func showFailedToGetRatesAlert() {
        showProblemAlert(title: "Failed to get rates", message: "Please try again later.")
    }
    
    /// Called by the above two function to display the alert with their specified titles and messages.
    private func showProblemAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            print("OK tapped")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Dismisses the keyboard when the user taps outside the input field.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource

/// Conformance to the table view data source protocol for populating the table view with fluctuation data.
///
/// Adding the UITableView related conformance here for clean coding purposes.
extension HomeViewController: UITableViewDataSource {
    
    /// Returns the number of rows in the table view.
    ///
    /// This includes one row for Bitcoin and additional rows for each favorite currency.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        KeychainAccess.shared.retrieveFavoriteCurrencies().count + 1
    }
    
    /// Configures and returns the cell for the row at the given index path.
    ///
    /// The first row displays Bitcoin data, and subsequent rows display favorite currency data along with growth trend images.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        
        let bitcoinAmount: Double = KeychainAccess.shared.retrieveBitcoinAmount() ?? 0.0
        
        if indexPath.row == 0 {
            cell.currencyCodeLabel.text = "BTC"
            cell.amountLabel.text = String(bitcoinAmount)
            cell.growthImageView.isHidden = true
        } else {
            let currencyCode: String = KeychainAccess.shared.retrieveFavoriteCurrencies()[indexPath.row - 1]
            let currencyAmount: Double = bitcoinAmount * (viewModel.currencyRates?[currencyCode]?.endRate ?? 0.0)
            let change: Double = viewModel.currencyRates?[currencyCode]?.change ?? 0.0
            
            cell.currencyCodeLabel.text = currencyCode
            cell.amountLabel.text = String(currencyAmount)
            cell.growthImageView?.isHidden = (currencyAmount == 0.0)
            if change < 0.0 {
                cell.growthImageView.image = ImageFactory.downtrendImage
                cell.growthImageView.tintColor = .blue
            } else if change > 0.0 {
                cell.growthImageView.image = ImageFactory.uptrendImage
                cell.growthImageView.tintColor = .bitcoinOrange
            } else {
                cell.growthImageView.image = ImageFactory.flattrendImage
                cell.growthImageView.tintColor = .lightGray
            }
        }
        
        return cell
    }
}
