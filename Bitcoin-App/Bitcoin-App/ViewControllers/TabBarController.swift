//
//  TabBarController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

/// A custom tab bar controller that manages the main navigation of the app.
///
/// This class is responsible for setting up, customising, and displaying the tab bar with
/// two main view controllers: `HomeViewController` and `FavoritesViewController`.
class TabBarController: UITabBarController {
    
    /// Called after the controller's view is loaded into memory.
    ///
    /// This method sets the tab bar's tint color and unselected item color,
    /// then configures the `HomeViewController` and `FavoritesViewController`
    /// with their respective tab bar items and embeds them in navigation controllers.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the tint color for selected tab bar items and the color for unselected items.
        tabBar.tintColor = .bitcoinOrange
        tabBar.unselectedItemTintColor = .gray
        
        // Set up the Home tab.
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(title: "", image: ImageFactory.linesImage, tag: 0)
        
        // Set up the Favorites tab.
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesViewController.tabBarItem = UITabBarItem(title: "", image: ImageFactory.starImage, tag: 1)
        
        // Add the view controllers to the tab bar
        viewControllers = [homeViewController, favoritesViewController]
    }
}
