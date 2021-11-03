//
//  SettingsViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 25/06/2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var answeredQuestionsLabel: UILabel!
    @IBOutlet var correctAnsweresLabel: UILabel!
    @IBOutlet var accurasyLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    var navBarConfiguration: NavigationBarConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // NavBar Configuration
        navBarConfig()
        
        // UIObjects Configuration
        UIObjectsConfig()
    }
    
    // MARK: Helper Functions
    // NavBar Configuration
    func navBarConfig() {
        navBarConfiguration = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navBarConfiguration.navBarWithBackButton()
    }
    
    // Configures the buttons and label texts
    func UIObjectsConfig() {
        labelConfiguration()
        
        UIObjectsConfiguration.buttonConfiguration(button: logoutButton)
    }
    
    // Set text to the labels
    func labelConfiguration() {
        firstNameLabel.text = "First Name: \(DataModel.userData.firstName)"
        lastNameLabel.text = "Last Name: \(DataModel.userData.lastName)"
        emailLabel.text = "Email: \(DataModel.userData.email)"
        
        let correctlyAnsweredQuestions = DataModel.userData.Score / 10
        var accurasy: Int!
        if DataModel.userData.questionsAnswered == 0 {
            accurasy = 100
        }
        else{
            accurasy = (((DataModel.userData.questionsAnswered - (DataModel.userData.questionsAnswered - correctlyAnsweredQuestions)) / DataModel.userData.questionsAnswered) * 100 )
            
        }
        accurasyLabel.text = "Accurasy: \(accurasy!) %"
        correctAnsweresLabel.text = "Correct Answered Questions: \(correctlyAnsweredQuestions)"
        answeredQuestionsLabel.text = "Answered Questions: \(DataModel.userData.questionsAnswered)"
        scoreLabel.text = "Score: \(DataModel.userData.Score) points"
    }
    
    // MARK: Button Action
    // Logout user, transfer to the first navigationController and set it as rootViewController
    @IBAction func logoutButtonAction(_ sender: Any) {
        DataModel.userData = User(firstName: "", lastName: "", email: "", Score: 0, uiD: "", questionsAnswered: 0)
        DataModel.userImage = nil
        navigationController?.popToRootViewController(animated: true)
        navigationController?.topViewController?.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        let nc = storyboard?.instantiateViewController(withIdentifier: "LoginNC") as! UINavigationController
        self.view.window?.rootViewController = nc
        self.view.window?.makeKeyAndVisible()
    }
}




