//
//  AboutViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 21/10/21.
//

import Foundation
import UIKit

class AboutViewController: UIViewController{
    var navBarConfiguration: NavigationBarConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarConfig()
    }
    
    // Navbar Configuration
    func navBarConfig() {
        navBarConfiguration = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navBarConfiguration.navBarWithBackButton()
    }
}
