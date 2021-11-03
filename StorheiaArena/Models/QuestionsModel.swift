//
//  QuestionsModel.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 16/06/2021.
//

import Foundation


struct Question: Codable, Equatable {
    let answer1: String
    let answer2: String
    let answer3: String
    let question: String
}


