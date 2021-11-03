//
//  UIObjectsConfiguration.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 20/10/21.
//

import Foundation
import UIKit

class UIObjectsConfiguration:UIViewController{
    
    // Configures UIButton
    class func buttonConfiguration(button: UIButton) {
        button.layer.cornerRadius = button.frame.width / 30
        button.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
    }
    
    // Configures UITextField
    class func textFieldConfiguration(textField: UITextField) {
        textField.layer.borderWidth = 0.7
        textField.layer.cornerRadius = textField.frame.width / 30
        textField.clipsToBounds = true
        textField.layer.masksToBounds = true
        textField.layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.8156862745, blue: 0.462745098, alpha: 1)
    }
}
