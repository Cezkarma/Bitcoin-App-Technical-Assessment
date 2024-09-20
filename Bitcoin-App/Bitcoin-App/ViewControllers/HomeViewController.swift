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
        currenciesTableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrencyTableViewCell")
        currenciesTableView.dataSource = self
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
            KeychainAccess.shared.storeBitcoinAmount(bitcoinAmount)
            print(KeychainAccess.shared.retrieveBitcoinAmount() ?? 0.0)
            currenciesTableView.reloadData()
        } else {
            showInvalidAmountAlert()
            return
        }
    }
    
    //This function displays an alert if the user has input an invalid amount.
    private func showInvalidAmountAlert() {
        let alert = UIAlertController(title: "Invalid input", message: "Please make sure that you input a valid decimal amount.", preferredStyle: .alert)
        
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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        cell.currencyCodeLabel.text = "BTC"
        cell.amountLabel.text = String(KeychainAccess.shared.retrieveBitcoinAmount() ?? 0.0)
        
        return cell
    }
}
