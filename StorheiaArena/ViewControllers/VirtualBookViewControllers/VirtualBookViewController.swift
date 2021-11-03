//
//  VirtualBookViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 14/8/21.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

var ref: DatabaseReference!

var messages: [DataSnapshot]! = []


var navigationBarConfig: NavigationBarConfiguration!

class VirtualBookViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Configure navBar title and Items
        navBarConfig()
        
        tableView.delegate = self
        
        // Download messages from Firebase and update tableView
        databaseConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        messages = []
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Configure navBar title and Items
    func navBarConfig() {
        navigationBarConfig = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navigationBarConfig.navBarWithAddMessageButton()
    }
    
    // Control the UI objects
    func activityController(isStopped:Bool){
        if isStopped{
            activityIndicator.stopAnimating()
            navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
            navigationController?.navigationItem.rightBarButtonItem?.isEnabled = true
            tableView.alpha = 1
        }
        else {
            activityIndicator.startAnimating()
            navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
            navigationController?.navigationItem.rightBarButtonItem?.isEnabled = true
            tableView.alpha = 0.7
        }
    }
    
    // Scroll to the bottom of the tableView
    func scrollToBottom(){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: messages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    
    // Download messages from Firebase and update tableView
    func databaseConfig() {
        // Controls activity indicator
        activityController(isStopped: false)
        
        FirebaseClient.getFilteredMessages { data, error in
            // In case of failure, inform the user
            if error != nil {
                AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: error!.localizedDescription, buttonTitle: "Ok", viewController: self)
            }
            else {
                messages = data
                self.tableView.reloadData()
                self.activityController(isStopped: true)
                
                // Scroll to the bottom
                self.scrollToBottom()
            }
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension VirtualBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Update custom cell labels with text from messages
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MessageCellView
        
        let snap = messages[indexPath.row].value as! [String:Any]
        
        cell.cellNameLabel.text = snap["username"] as! String
        cell.cellDateLabel.text = snap["messageDate"] as! String
        cell.cellTextLabel.text = snap["userText"] as! String
    
        return cell
    }
}
