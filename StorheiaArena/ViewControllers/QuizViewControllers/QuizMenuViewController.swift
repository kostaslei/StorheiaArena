//
//  QuizMenuViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 28/05/2021.
//

import Foundation
import UIKit
import FirebaseFirestore

class QuizMenuViewController: UIViewController{
    @IBOutlet var quiz1Button: UIButton!
    @IBOutlet var quiz2Button: UIButton!
    
    var navigationBarConfig: NavigationBarConfiguration!
    
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        // Configures the navigation bar
        navBarConfig()
        
        // Configures Buttons
        UIObjectsConfig()
    }
    
    // Set title and buttons on navigation bar
    func navBarConfig() {
        navigationBarConfig = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navigationBarConfig.navBarWithBackButton()
    }
    
    // UIObjects configuration
    func UIObjectsConfig() {
        UIObjectsConfiguration.buttonConfiguration(button: quiz1Button)
        UIObjectsConfiguration.buttonConfiguration(button: quiz2Button)
    }
    
    // Get the questions with a spesific number on their Firebase path
    func getQuestions(withNumber: Int) {
        questions.removeAll()
        
        // Get question set with the spesific number
        FirebaseClient.getQuestionSetFromFirestore(withNumber: withNumber) { questionsDocument, error in
            
            // If response doesn't exist, alert user
            if error != nil {
                AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: "Document does not exist!", buttonTitle: "OK", viewController: self)
            }
            
            // If questionSet exists, strore questions on question array
            if let questionsDocument = questionsDocument {
                for i in questionsDocument.keys{
                    let dict = questionsDocument[i] as! Dictionary<String, String>
                    
                    self.questions.append(Question(answer1: dict["answer1"]!, answer2: dict["answer2"]!, answer3: dict["answer3"]!, question: dict["question"]!))
                }
                
                // Transfer to next viewController and pass the data
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuizMapVC") as! QuizMapViewController
                vc.questions = self.questions
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func quiz1ButtonAction(_ sender: Any) {
        // Get the new questions
        getQuestions(withNumber: 1)
    }
    @IBAction func quiz2ButtonAction(_ sender: Any) {
        // Get the new questions
        getQuestions(withNumber: 2)
    }
}
