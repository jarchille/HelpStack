//
//  ViewController.swift
//  HelpStack
//
//  Created by Jonathan Archille on 1/2/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ChatViewController: UITableViewController {
    
    var messages = Array<FIRDataSnapshot>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
        
        checkifUserLoggedIn()
        fetchUser()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let messageSnapshot = messages[indexPath.row]
        print(messageSnapshot)
        let message = messageSnapshot.value as? Dictionary<String, String>
        if let name = message?["name"], let text = message?["email"]
        {
            cell.textLabel?.text = name + ": " + text
        }
        
        return cell
    }
    
    // MARK: - Helper functions
    
    func checkifUserLoggedIn () {
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //corrects "unbalanced call" error due to too many views being loaded simultaneously
        }
        
    }
    
    func fetchUser() {
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let _ = snapshot.value as? [String: Any] {
                
                self.messages.append(snapshot)
            }
            
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
            
            
        })
        
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
            
        } catch let logoutError {
            print(logoutError)
        }
        
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
}

