//
//  LoginController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    @IBOutlet weak var email_textfield_login: UITextField!
    @IBOutlet weak var password_textfield_login: UITextField!
    
    
    @IBAction func logInClicked(_ sender: Any) {
        logIn()
    }
    
    @objc func logIn() {
        
        let email: String! = email_textfield_login.text
        let password: String! = password_textfield_login.text
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                print("User logged in!")
                self.performSegue(withIdentifier: "showShoppingListView", sender: self)


            } else {
                print("Error logging in!")
            }
        }
    }
    
}
