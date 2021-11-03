//
//  QuizViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 21/05/2021.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answer1: UIButton!
    @IBOutlet var answer2: UIButton!
    @IBOutlet var answer3: UIButton!
    var question : Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
        self.questionLabel.text = self.question.question
        
        randomQuestionToButtonTitles()
        
        
    }
    
    // Configure navBar title
    func navBarConfig() {
       let navBarConfig = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navBarConfig.navBarTitleImage()
    }
    
    // UIObjects configuration
    func UIObjectsConfig() {
        UIObjectsConfiguration.buttonConfiguration(button: answer1)
        UIObjectsConfiguration.buttonConfiguration(button: answer2)
        UIObjectsConfiguration.buttonConfiguration(button: answer3)
    }
    
    // Asign randomly the quiz answeres to the three buttons
    func randomQuestionToButtonTitles() {
        let answers = [question.answer1,question.answer2, question.answer3]
        
        let firstButton = answers.randomElement()
        let secondButton = answers.filter { answer in
            answer != firstButton}.randomElement()
        let thirdButton = answers.filter { answer in
            answer != firstButton && answer != secondButton
        }[0]
        
        self.answer1.setTitle(firstButton, for: .normal)
        self.answer2.setTitle(secondButton, for: .normal)
        self.answer3.setTitle(thirdButton, for: .normal)
    }
    
    // Check if answer is correct
    func checkIfAnswerCorrect(forButton button: UIButton) -> Bool {
        if button.titleLabel?.text == question.answer1 {
            return true
        }
        else {
            return false
        }
    }
    
    // Update user's score on firebase
    func quizScoreUpdate(forButton button: UIButton) {
        
        // If answer correct
        if checkIfAnswerCorrect(forButton: button){
            DataModel.userData.Score += 10
            
            // Send updated score on firebase
            FirebaseClient.updateUserScoreOnFirebase(score: DataModel.userData.Score) { score, error in
                if error != nil {
                    AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: error!.localizedDescription, buttonTitle: "OK", viewController: self)
                }
                else {
                    AlertNotifications.oneButtonAlertNotification(alertTitle: "Well done!", alertMessage: "", buttonTitle: "OK", viewController: self)
                }
            }
        }
        else {
            AlertNotifications.oneButtonAlertNotification(alertTitle: "Wrong answer", alertMessage: "", buttonTitle: "OK", viewController: self)
        }
    }
    
    // Update user's questions answered on firebase
    func updateQuestionsAnswered() {
        DataModel.userData.questionsAnswered += 1
        FirebaseClient.updateQuestionsAnsweredOnFirebase(questions: DataModel.userData.questionsAnswered) { questions, error in
            if error != nil {
                AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: error!.localizedDescription, buttonTitle: "OK", viewController: self)
            }
            else{
                print("Questions Answered Updated")
            }
        }
    }
    
    // MARK: BUTTON ACTIONS
    @IBAction func answer1Action(_ sender: Any) {
        quizScoreUpdate(forButton: answer1)
        updateQuestionsAnswered()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func answer2Action(_ sender: Any) {
        quizScoreUpdate(forButton: answer2)
        updateQuestionsAnswered()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func answer3Action(_ sender: Any) {
        quizScoreUpdate(forButton: answer3)
        updateQuestionsAnswered()
        navigationController?.popViewController(animated: true)
    }
}
