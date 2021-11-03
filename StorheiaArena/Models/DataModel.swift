//
//  Data Model.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 28/06/2021.
//

import Foundation

// Stores the user data so they can be accessed globally.
struct DataModel{
    static var userData: User!
    static var userImage: Data?
    static var questionsAsked: [Question] = []
}
