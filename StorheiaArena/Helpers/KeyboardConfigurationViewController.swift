//
//  KeyboardConfigurationViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 11/10/21.
//

import Foundation
import UIKit

class KeyboardConfigurationViewController: NSObject {
    
    var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // Hide keyboard when tapped around
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    // Hide keyboard
    @objc func hideKeyboard() {
        viewController.view.endEditing(true)
    }
}

extension KeyboardConfigurationViewController: UITextFieldDelegate{
    
    // Hide keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController.view.endEditing(true)
        return false
    }
}
