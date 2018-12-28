//
//  LoginController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    @IBOutlet weak var email_textfield_login: UITextField!
    @IBOutlet weak var password_textfield_login: UITextField!
    
    
    @IBAction func logInClicked(_ sender: Any) {
        logIn()
    }
    
    @objc func logIn() {
        
        
        guard let email = email_textfield_login.text, !email.isEmpty else {
            showWarning(message: "Please fill in your email address")
            return
        }
        
        guard let password = password_textfield_login.text, !password.isEmpty else {
            showWarning(message: "Please fill in your password")
            return
        }
        
        login(email: email, password: password)
        
    }
    
    
    func login(email: String, password: String) {
        //SOURCE: https://firebase.google.com/docs/auth/ios/password-auth
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                print("User logged in!")
                self.performSegue(withIdentifier: "showShoppingListView", sender: self)
            } else {
                self.showWarning(message: "Invalid email or password")
            }
        }
    }
    
    func showWarning(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    
}
