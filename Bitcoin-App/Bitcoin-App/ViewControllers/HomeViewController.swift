//
//  ViewController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/19.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    @IBOutlet weak var currenciesTableView: UITableView!
    
    private let viewModel: HomeViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The code below dismisses the keyboard if the user taps elsewhere on the screen.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        //
        
        currenciesTableView.rowHeight = UITableView.automaticDimension
        currenciesTableView.estimatedRowHeight = 65.0
        currenciesTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        currenciesTableView.dataSource = self
        
        viewModel.showFailedToGetRatesAlert = showFailedToGetRatesAlert //Sending function as a closure to viewModel
        viewModel.getFluctuationRates()
    }
    
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
    
    private func showInvalidAmountAlert() {
        showProblemAlert(title: "Invalid input", message: "Please make sure that you input a valid, positive decimal amount.")
    }
    
    private func showFailedToGetRatesAlert() {
        showProblemAlert(title: "Failed to get rates", message: "Please try again later.")
    }
    
    private func showProblemAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            print("OK tapped")
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //This is the function that dismisses the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Adding the UITableView related conformance here for clean coding purposes.
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        KeychainAccess.shared.retrieveFavoriteCurrencies().count + 1
    }
    
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
