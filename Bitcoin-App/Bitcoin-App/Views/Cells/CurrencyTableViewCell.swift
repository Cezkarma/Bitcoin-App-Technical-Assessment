//
//  CurrencyTableViewCell.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/20.
//

import Foundation
import UIKit

/// A custom table view cell for displaying currency information.
class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var growthImageView: UIImageView!
}
