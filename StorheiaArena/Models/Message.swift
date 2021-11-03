//
//  Message.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 8/9/21.
//

import Foundation
import FirebaseDatabase

struct Message {
    var creationDate: Any
    var username: String
    var userText: String
    var userImage: String
    var messageDate: String

    
    var dictionary: [String:Any] {
        return [
            "creationDate": creationDate,
            "username": username,
            "userText": userText,
            "userImage": userImage,
            "messageDate": messageDate
        ]
    }
}
