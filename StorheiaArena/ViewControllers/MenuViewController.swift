//
//  MenuViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 27/05/2021.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class MenuViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet var quizButton: UIButton!
    @IBOutlet var virtualBookButton: UIButton!
    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var weatherView: UIView!
    let locationManager = CLLocationManager()
    
    var temperature: String!
    var feelsLikeTemperature: String!
    var windDirection: String!
    var windSpeed: String!
    var imageData: Data!
    
    var navBarConfiguration: NavigationBarConfiguration!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        navBarConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIObjects Configuration
        UIObjectsConfig()
        
        // Ask user for location authorization
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: FUNCTIONS
    // Navbar Configuration
    func navBarConfig() {
        navBarConfiguration = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navBarConfiguration.navBarWithSettingsButton()
    }
    
    // UIObjects configuration
    func UIObjectsConfig() {
        weatherView.layer.cornerRadius = 15
        UIObjectsConfiguration.buttonConfiguration(button: quizButton)
        UIObjectsConfiguration.buttonConfiguration(button: virtualBookButton)
        UIObjectsConfiguration.buttonConfiguration(button: aboutButton)
        
        // Set label texts and imageView image
        windLabel.text = "Wind: \(windDirection ?? "") \(windSpeed ?? "")"
        temperatureLabel.text = temperature
        feelsLikeLabel.text = "Feels like: \(feelsLikeTemperature ?? "")"
        imageView.image = UIImage(data: imageData)
    }
    
    @objc func settingsButtonAction(sender: UIButton!) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        //vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

