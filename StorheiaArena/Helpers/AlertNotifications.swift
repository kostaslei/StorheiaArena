//
//  AlertNotifications.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 28/9/21.
//

import Foundation
import UIKit

class AlertNotifications {
    
    // A single button Alert Notification function. Gets as parameters a title, a message, a button title
    // and a viewController.
    class func oneButtonAlertNotification(alertTitle: String, alertMessage: String, buttonTitle: String, viewController: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
