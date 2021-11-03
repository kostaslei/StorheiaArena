//
//  SignUpViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 14/06/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController{
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var activityController: UIActivityIndicatorView!
    @IBOutlet var stackView: UIStackView!
    
    var keyboardConfig: KeyboardConfigurationViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIObjectsConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIObjectsConfig()
        keyboardConfiguration()
    }
    
    // MARK: HELPER FUNCTIONS
    
    // Keyboard Configuration. When the user taps outside the textField, dimiss keyboard.
    func keyboardConfiguration() {
        keyboardConfig = KeyboardConfigurationViewController(viewController: self)
        keyboardConfig.hideKeyboardWhenTappedAround()
        emailTextField.delegate = keyboardConfig
        passwordTextField.delegate = keyboardConfig
        lastNameTextField.delegate = keyboardConfig
        firstNameTextField.delegate = keyboardConfig
    }
    
    // UIObjects configuration
    func UIObjectsConfig() {
        UIObjectsConfiguration.textFieldConfiguration(textField: emailTextField)
        UIObjectsConfiguration.textFieldConfiguration(textField: passwordTextField)
        UIObjectsConfiguration.textFieldConfiguration(textField: lastNameTextField)
        UIObjectsConfiguration.textFieldConfiguration(textField: firstNameTextField)
        
        UIObjectsConfiguration.buttonConfiguration(button: loginButton)
        UIObjectsConfiguration.buttonConfiguration(button: signUpButton)
    }
    
    // Validate the fields
    func validateFields() -> Bool {
        
        // Check if the user has filled all the fields
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" || emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespaces) == ""
        {return false}
        else {return true}
    }
    
    // Control the UI objects when the signup button is clicked
    func activityController(isStopped:Bool){
        if isStopped{
            activityController.stopAnimating()
            signUpButton.isEnabled = true
            firstNameTextField.isEnabled = true
            lastNameTextField.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            stackView.alpha = 1
        }
        else {
            activityController.startAnimating()
            signUpButton.isEnabled = false
            firstNameTextField.isEnabled = false
            lastNameTextField.isEnabled = false
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
    
    // Transfer user on the next ViewController
    func transitionToMenu() {
        let nc = storyboard?.instantiateViewController(withIdentifier: "MenuNC") as! UINavigationController
        nc.modalPresentationStyle = .fullScreen
        view.window?.rootViewController = nc
        view.window?.makeKeyAndVisible()
    }
    
    // MARK: BUTTONS ACTIONS
    
    // Dismiss ViewController
    @IBAction func loginButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Validate fields and signup user
    @IBAction func signUpButtonAction(_ sender: Any) {
        activityController(isStopped: false)
        
        //create cleanned version of the data
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespaces)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespaces)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespaces)
        
        // If not all of the fields are filled, inform the user
        if validateFields() != true {
            self.showError("Please fill in all the required fields.")
        }
        
        // All the fiels are filled
        else {
            //create a user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //check for errors
                if  err != nil {
                    //there was an error creating the user
                    self.showError(err!.localizedDescription)
                }
                else {
                    //The user created successfully now store the info
                    let db = Firestore.firestore()
                    
                    // Pass the user data to the DataModel so they can be accessed globally in the app
                    DataModel.userData =  User(firstName: firstName, lastName: lastName, email: email, Score: 0, uiD: (result?.user.uid)!, questionsAnswered: 0)
                    
                    // Pass the user data to the firebase database
                    db.collection("users").document(DataModel.userData.uiD).setData(DataModel.userData.Dictionary){ (error) in
                        if error != nil {
                            //Show error message
                            self.showError("Error shaving users data. Please try again.")
                        }
                        // If the user is created successfully stop activityController and transfer user to the next viewController
                        else {
                            let nc = self.storyboard?.instantiateViewController(identifier: "MenuNC") as? UINavigationController
                            let vc = nc?.topViewController as! MenuViewController
                            
                            WeatherAPIClient.taskForGETRequest(url: WeatherAPIClient.Endpoints.weatherCurrent.url, response: CurrentWeatherResponse.self) { response, error in
                                // API response
                                if let response = response{
                                    // Download image from a url and asign the response to a UIImageView
                                    FirebaseClient.downloadImage(url: URL(string: "https:" + response.current.condition.icon)!) { data, error in
                                        if let data = data {
                                            vc.imageData = data
                                            vc.temperature = "\(response.current.temp_c) °C"
                                            vc.feelsLikeTemperature = "\(response.current.feelslike_c) °C"
                                            vc.windDirection = response.current.wind_dir
                                            vc.windSpeed = "\(response.current.gust_kph) kph"
                                            
                                            self.activityController(isStopped: true)
                                            self.view.window?.rootViewController = nc
                                            self.view.window?.makeKeyAndVisible()
                                        }
                                        
                                        // Couldnt download the picture
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
                    }
                }
            }
        }
    }
}
