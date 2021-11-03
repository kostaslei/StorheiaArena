//
//  User.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 14/06/2021.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var email: String
    var Score: Int
    let uiD: String
    var questionsAnswered: Int
    
    var Dictionary: [String: Any] {
        return ["First Name": firstName,
                "Last Name": lastName,
                "Email": email,
                "Score":Score,
                "UID":uiD,
                "Questions Answered": questionsAnswered
        ]
    }
}
