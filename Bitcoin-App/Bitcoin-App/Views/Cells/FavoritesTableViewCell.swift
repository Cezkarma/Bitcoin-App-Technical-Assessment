//
//  FavoritesTableViewCell.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

//Extending AnyObject ensures that this protocol can only be adopted by class (reference) types
protocol FavoritesTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: FavoritesTableViewCell)
}

class FavoritesTableViewCell: UITableViewCell {
    
    weak var delegate: FavoritesTableViewCellDelegate?
    
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        delegate?.didTapFavoriteButton(on: self)
    }
}
