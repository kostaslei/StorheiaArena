//
//  AddMessageViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 15/9/21.
//

import Foundation
import UIKit
import FirebaseDatabase

class AddMessageViewController: UIViewController{
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var navBarConfiguration: NavigationBarConfiguration!
    
    // get the current date and time
    let currentDateTime = Date()

    // initialize the date formatter and set the style
    let dateFormatter = DateFormatter()
    var date:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Configure NavBar
        navBarConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateConfig()
                
        userNameLabel.text = DataModel.userData.firstName + " " + DataModel.userData.lastName
        dateLabel.text = dateFormatter.string(from: currentDateTime)
    }
    
    // Configures NavigationBar
    func navBarConfig() {
        navigationBarConfig = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navigationBarConfig.navBarWithBackButton()
    }
    
    // Transform the date into a string on a spesific format
    func dateConfig() {
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "HH:mm, d MMMM yyyy"
        date = dateFormatter.string(from: currentDateTime)
    }
    
    // Controlls the UI objects when the post button is clicked
    func buttonAction(sendToServer: Bool) {
        if sendToServer{
            messageTextField.isEnabled = false
            postButton.isEnabled = false
            activityIndicator.startAnimating()
            postButton.isEnabled = false
            navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            view.alpha = 0.7
        }
        else {
            messageTextField.isEnabled = true
            postButton.isEnabled = true
            activityIndicator.stopAnimating()
            postButton.isEnabled = true
            navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
            view.alpha = 1
        }
    }
    
    // Check if textfield is full
    func textFieldIsFull(textField:UITextField) -> Bool{
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            return true
        }
        else {
            return false
        }
    }
    
    // Post the user message to Database, handle errors, inform user and dismiss ViewController
    func postMessageToDatabase() {
        let message = Message(creationDate: FirebaseDatabase.ServerValue.timestamp(), username: userNameLabel.text!, userText: messageTextField.text!, userImage: "photo", messageDate: date!)
        
        // If textfield is full
        if textFieldIsFull(textField: messageTextField){
            // Post message to Database
            FirebaseClient.postMessageToDatabase(message: message, viewController: self) { response, error in
                
                // If success, handle the UI objects and dismiss viewController
                if response != nil {
                    self.buttonAction(sendToServer: false)
                    self.navigationController?.popViewController(animated: true)
                }
                
                // If failure, inform user and handle UI objects
                if error != nil {
                    AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: error?.localizedDescription ?? "An error has occurred while posting the message. Please try again.", buttonTitle: "Ok", viewController: self)
                    self.buttonAction(sendToServer: false)
                }
                
                // If we don't have response for 10 sec
                else {
                    AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: "Connection timed out! Please check your connection!", buttonTitle: "Ok", viewController: self)
                    self.buttonAction(sendToServer: false)
                }
            }
        }
        
        // If textfield is empty
        else{
            AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: "Please fill in the field!", buttonTitle: "Ok", viewController: self)
            buttonAction(sendToServer: false)
        }
    }

    // Post message button action
    @IBAction func postActionButton(_ sender: Any) {
        buttonAction(sendToServer: true)
        postMessageToDatabase()
    }
}

