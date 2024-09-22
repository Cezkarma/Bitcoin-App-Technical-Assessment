//
//  FavoritesTableViewCell.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

/// A protocol to that specifies a function to be called when the favorite button is clicked.
///
/// This protocol will be conformed to by the FavoritesViewController, following a Delegate pattern, so that it can perform UI-based actions when the favorite button is clicked.
///
/// - Note: Extending AnyObject ensures that this protocol can only be adopted by class (reference) types
protocol FavoritesTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: FavoritesTableViewCell)
}

/// A custom table view cell for displaying currency symbols and if they've been favorited or not.
class FavoritesTableViewCell: UITableViewCell {
    
    weak var delegate: FavoritesTableViewCellDelegate?
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        delegate?.didTapFavoriteButton(on: self)
    }
}
