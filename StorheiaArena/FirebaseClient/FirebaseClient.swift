//
//  FirebaseClient.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 28/06/2021.
//

import Foundation
import UIKit
import Firebase

class FirebaseClient {
    
    // Get user's data from firestore
    static func getUserDataFromFirestore(completion: @escaping ([String : Any]?,Error?) -> Void){
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        // Reference of the user's path in database
        let docRef = db.collection("users").document(userID)
        
        // Get user's Data
        docRef.getDocument { (document, error) in
            
            // If document exist return data asychronously
            if let document = document, document.exists {
                if let data = document.data(){
                    
                    DispatchQueue.main.async {
                        completion(data,nil)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
        }
    }
    
    // Update user's score on firebase
    static func updateUserScoreOnFirebase(score: Int, completion: @escaping (Int?,Error?) -> Void) {
        let db = Firestore.firestore()
        
        // User's ID
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let docRef = db.collection("users").document(userID)
        
        // Updtae score
        let childUpdates = ["Score": score]
        docRef.updateData(childUpdates)
        DispatchQueue.main.async {
            completion(score,nil)
        }
    }
    
    // Update user's questions answered on firebase
    static func updateQuestionsAnsweredOnFirebase(questions: Int, completion: @escaping (Int?,Error?) -> Void) {
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let docRef = db.collection("users").document(userID)
        
        let childUpdates = ["Questions Answered": questions]
        docRef.updateData(childUpdates)
        DispatchQueue.main.async {
            completion(questions,nil)
        }
    }
    
    // Download an image from a URL
    static func downloadImage(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data,nil)
                }
            }
        }
        task.resume()
        return task
    }
    
    // Get question set from firestore
    static func getQuestionSetFromFirestore(withNumber: Int, completion: @escaping ([String:Any]?,Error?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("QuestionSets").document("QuestionSet\(withNumber)")
        
        // Force the SDK to fetch the document from the cache. Could also specify
        // FirestoreSource.server or FirestoreSource.default.
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let questionsDocument = document.data()!
                
                DispatchQueue.main.async {
                    completion(questionsDocument,nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
        }
    }
    
    // Get users messages from database filtered by date
    static func getFilteredMessages(completion: @escaping ([DataSnapshot]?,Error?) -> Void) {
        ref = Database.database(url: "https://storheia-arena-default-rtdb.europe-west1.firebasedatabase.app").reference()
        var messages: [DataSnapshot]! = []
        
        ref.child("messages").queryOrdered(byChild: "creationDate").queryStarting(atValue: 1633997299528).observe(.childAdded) { (snap: DataSnapshot) in
            messages.append(snap)
            DispatchQueue.main.async {
                completion(messages,nil)
            }
            // In case of failure
        } withCancel: { error in
            DispatchQueue.main.async {
                completion(nil,error)
            }
        }
    }
    
    // Post message to database
    static func postMessageToDatabase(message: Message, viewController: UIViewController, completion: @escaping (DatabaseReference?, Error?) -> Void) {
        var ref: DatabaseReference!
        
        ref = Database.database(url: "https://storheia-arena-default-rtdb.europe-west1.firebasedatabase.app").reference()

        // If the function runs for 10 minutes with no answer
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            completion(nil,nil)
            
            // Delete any write events on database
            ref.child("messages/").childByAutoId().database.purgeOutstandingWrites()
            return
        }
        
        let userMessage = message
        ref.child("messages/").childByAutoId().setValue(userMessage.dictionary) { error, databaseReference in
            
            if error == nil {
                DispatchQueue.main.async {
                    completion(databaseReference,nil)
                }
            }
            
            else {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
        }
    }
}
