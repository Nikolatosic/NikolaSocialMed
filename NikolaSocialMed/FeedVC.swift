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

// UIImagePickerControllerDelegate, UINavigationControllerDelegate for image picker
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CirlceView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // Getting Objects from firebase Database (snapshot.value print JSON objects)
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = [] // <- if we make some changes on Firebase this will prevent to duplicate a objects
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            print(self.posts.count, "POSTS")
            self.tableView.reloadData()
        })
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return FeedCell()
        }
    }
    
    // MARK: - UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
        } else {
            print("NIKK: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
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
    
    @IBAction func addImageTapped(_ sender: Any) {
        print("Tapped")
        present(imagePicker, animated: true, completion: nil)
    }
    

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
