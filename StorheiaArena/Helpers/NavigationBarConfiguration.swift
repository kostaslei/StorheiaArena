//
//  NavigationBarConfiguration.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 30/9/21.
//

import Foundation
import UIKit

class NavigationBarConfiguration{
    
    let navigationController: UINavigationController
    let vc: UIViewController
    
    init(navController: UINavigationController, vc: UIViewController) {
        self.navigationController = navController
        self.vc = vc
    }
    
    // Set navBar title image
     func navBarTitleImage() {
        
        let image = UIImage(named: "Main-logo-high-rez-Storheia-Arena04.png")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navigationController.navigationBar.frame.size.width
        let bannerHeight = navigationController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        vc.navigationItem.titleView = imageView
    }
    
    // Set Navbar button Item with actions
    func navBarButtonItem(isLeftBarButtonItem: Bool, systemNameImage: String) {
        
        let navButton = UIButton(type: .system)
        let backImage = UIImage(systemName: systemNameImage)
        navButton.tintColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
        navButton.setImage(backImage, for: .normal)
    
        navButton.frame = CGRect(x: 0, y: 0, width: (backImage?.size.width)!, height: (backImage?.size.height)!)
        
        // In case of back button
        if isLeftBarButtonItem {
            navButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navButton)
            vc.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
        }
        
        else {
            // In case of Settings Button
            if systemNameImage == "gearshape" {
                navButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navButton)
                vc.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
            }
            // In case of addMessage Button
            else if systemNameImage == "plus" {
                navButton.addTarget(self, action: #selector(addMessageButtonAction), for: .touchUpInside)
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navButton)
                vc.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
            }
        }
    }
    
    // Adds an empty button with no actions
    func navBarEmptyFillerButton(isLeftBarButtonItem: Bool,systemNameImage: String) {
        let emptyButton = UIButton()
        let image = UIImage(systemName: systemNameImage)
        emptyButton.frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        if isLeftBarButtonItem {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emptyButton)
        }
        
        else {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: emptyButton)
        }
    }
    
    // Navbar with title and back button
    func navBarWithBackButton() {
        navBarTitleImage()
        navBarButtonItem(isLeftBarButtonItem: true, systemNameImage: "chevron.backward")
        navBarEmptyFillerButton(isLeftBarButtonItem: false, systemNameImage: "chevron.backward")
    }
    
    // Navbar with title, back button and add message button
    func navBarWithAddMessageButton() {
        navBarTitleImage()
        navBarButtonItem(isLeftBarButtonItem: true, systemNameImage: "chevron.backward")
        navBarButtonItem(isLeftBarButtonItem: false, systemNameImage: "plus")
    }
    
    // Navbar with title, back button and settings button
    func navBarWithSettingsButton() {
        navBarTitleImage()
        navBarButtonItem(isLeftBarButtonItem: false, systemNameImage: "gearshape")
        navBarEmptyFillerButton(isLeftBarButtonItem: true, systemNameImage: "gearshape")
    }
    
    // Transfer to the next ViewController
    @objc func settingsButtonAction(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    // Pop ViewController
    @objc func backButtonAction(sender: UIButton!){
        navigationController.popViewController(animated: true)
    }
    
    // Transfer to the next ViewController
    @objc func addMessageButtonAction(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddMessageVC") as! AddMessageViewController
        navigationController.pushViewController(vc, animated: true)
    }
}
