//
//  SignInVC.swift
//  NikolaSocialMed
//
//  Created by Nikola Tosic on 7/14/17.
//  Copyright © 2017 Nikola Tosic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        pwdField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    // It's to early to perform seque in viewDidLoad and because that we set this in viewWillAppear
    override func viewDidAppear(_ animated: Bool) {
        // If user is logged go to FeedVC
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "FeedVC", sender: nil)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= kbSize.height - 100
            }
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += kbSize.height - 100
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailField.resignFirstResponder()
        pwdField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailField.resignFirstResponder()
        pwdField.resignFirstResponder()
        
        return true
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("NIKK: Unable to authenticate with Facebook - \(error!)")
            } else if result?.isCancelled == true {
                print("NIKK: User canceled Facebook authentication")
            } else {
                print("NIKK: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("NIKK: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("NIKK: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIKK: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    // MARK: - Firebase Auth (FB Button)
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if (error != nil) {
                print("NIKK: Unable to sign in with firebase - \(error!)")
            } else {
                print("NIKK: Sucessful sign in with firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    // Kaychain will prevent to logIn Every time when we start app
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        // this is call to write new user to Firebase
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("NIKK: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

