//
//  LoginViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 14/06/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController{
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    
    let db = Firestore.firestore()
    
    var keyboardConfig: KeyboardConfigurationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIObjectsConfig()
        keyboardConfiguration()
    }

    // MARK: HELPER FUNCTIONS
    
    // UIObjects configuration
    func UIObjectsConfig() {
        UIObjectsConfiguration.textFieldConfiguration(textField: emailTextField)
        UIObjectsConfiguration.textFieldConfiguration(textField: passwordTextField)
        
        UIObjectsConfiguration.buttonConfiguration(button: loginButton)
        UIObjectsConfiguration.buttonConfiguration(button: signUpButton)
    }
    
    // Keyboard Configuration. When the user taps outside the textField, dimiss keyboard.
    func keyboardConfiguration() {
        keyboardConfig = KeyboardConfigurationViewController(viewController: self)
        keyboardConfig.hideKeyboardWhenTappedAround()
        emailTextField.delegate = keyboardConfig
        passwordTextField.delegate = keyboardConfig
    }
    // Validate the fields
    func validateFields() -> Bool {
        // Check if the user has filled all the fields
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {return false}
        else {return true}
    }
    
    // Control the UI objects when the login button is clicked
    func activityController(isStopped:Bool){
        if isStopped{
            activityIndicator.stopAnimating()
            loginButton.isEnabled = true
            signUpButton.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            stackView.alpha = 1
        }
        else {
            activityIndicator.startAnimating()
            loginButton.isEnabled = false
            signUpButton.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            stackView.alpha = 0.7
        }
    }
    
    // Show error message and stop the activityController function
    func showError(_ message:String) {
        AlertNotifications.oneButtonAlertNotification(alertTitle: "Login Failed", alertMessage: message, buttonTitle: "OK", viewController: self)
        activityController(isStopped: true)
    }
    
    // Transfer user on the next ViewController and pass the data to the DataModel
    func transitionToMenu(user:User) {
        let nc = self.storyboard?.instantiateViewController(identifier: "MenuNC") as? UINavigationController
        let vc = nc?.topViewController as! MenuViewController
        
        // Get weather data from WeatherAPI
        WeatherAPIClient.taskForGETRequest(url: WeatherAPIClient.Endpoints.weatherCurrent.url, response: CurrentWeatherResponse.self) { response, error in
            // API response
            if let response = response{
                // Download image from a url and asign the response to a UIImageView
                FirebaseClient.downloadImage(url: URL(string: "https:" + response.current.condition.icon)!) { data, error in
                    if let data = data {
                        
                        // Pass data to the next VewController
                        vc.imageData = data
                        vc.temperature = "\(response.current.temp_c) °C"
                        vc.feelsLikeTemperature = "\(response.current.feelslike_c) °C"
                        vc.windDirection = response.current.wind_dir
                        vc.windSpeed = "\(response.current.gust_kph) kph"
                        
                        // Stores the user data on a struct
                        DataModel.userData = user
                        self.activityController(isStopped: true)
                        self.view.window?.rootViewController = nc
                        self.view.window?.makeKeyAndVisible()
                    }
                    // Couldn't download the picture
                    else{
                        print(error!.localizedDescription)
                    }
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: Get userData from Firestore
    
    // Get user data from Firestore
    func getUserData() {
        FirebaseClient.getUserDataFromFirestore { userData, error in
            
            // If userData exist then pass data to transitionToMenu function
            if userData != nil {
                self.transitionToMenu(user: User(firstName: userData!["First Name"] as! String, lastName: userData!["Last Name"] as! String, email: userData!["Email"] as! String, Score: userData!["Score"] as! Int, uiD: userData!["UID"] as! String,  questionsAnswered: userData!["Questions Answered"] as! Int))
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    // MARK:BUTTON ACTIONS
    @IBAction func loginButtonAction(_ sender: Any) {
        
        // Change UI objects
        activityController(isStopped: false)
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If not all of the fields are filled, inform the user
        if validateFields() != true {
            showError("Please fill in all the required filleds!")
        }
        
        // All the fiels are filled
        else{
            
            //Signing in user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                //Couldnt sign in
                if error != nil {
                    
                    // Change the response of the error in order to be more user friendly
                    if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.showError("There is no user found with these credentials.")
                    }
                    
                    // Inform the user for the error
                    else {
                        self.showError(error!.localizedDescription)
                    }
                }
                // Could sign in
                else{
                    self.getUserData()
                }
            }
        }
    }
    
    // Transfer user to signUp
    @IBAction func signUpButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
}

