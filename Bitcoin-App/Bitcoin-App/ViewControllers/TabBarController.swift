//
//  TabBarController.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .bitcoinOrange
        tabBar.unselectedItemTintColor = .gray
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(title: "", image: ImageFactory.linesImage, tag: 0)
        
        let favoritesViewController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesViewController.tabBarItem = UITabBarItem(title: "", image: ImageFactory.starImage, tag: 1)
        
        viewControllers = [homeViewController, favoritesViewController]
    }
}
