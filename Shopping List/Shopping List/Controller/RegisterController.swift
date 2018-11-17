//
//  RegisterController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    @IBOutlet weak var username_textfield_register: UITextField!
    @IBOutlet weak var password_textfield_register: UITextField!
    @IBOutlet weak var register_button_register: UIButton!
    
    
    @IBAction func registerClicked(_ sender: Any) {
        register()
    }
    
    
    @objc func register() {
        
        //The ! after String is needed because .text returns a String?
        let email: String! = self.username_textfield_register.text
        let password: String! = self.password_textfield_register.text
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
            } else {
                print("Error creating user!")
            }
        }
    }
    
    
}

