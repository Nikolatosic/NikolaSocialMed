//
//  FeedVC.swift
//  NikolaSocialMed
//
//  Created by Nikola Tosic on 7/17/17.
//  Copyright © 2017 Nikola Tosic. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
    }
    
    
    
    // MARK: - Actions
    // LogOut Button
    @IBAction func LogOutTapped(_ sender: UIButton) {
        
        if (self.presentingViewController != nil) {
            self.dismiss(animated: false, completion: nil)
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        print("NIKK: Keychain removed successfully")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
