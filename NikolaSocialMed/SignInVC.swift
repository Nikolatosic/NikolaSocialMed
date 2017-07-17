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

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("NIKK: Unable to authenticate with Firebase using email")
                        } else {
                            print("NIKK: Successfully authenticated with Firebase")
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
            }
        }
    }

}

