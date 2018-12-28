//
//  RegisterController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RegisterController: UIViewController {
    
    @IBOutlet weak var username_textfield_register: UITextField!
    @IBOutlet weak var password_textfield_register: UITextField!
    @IBOutlet weak var password2_textfield_register: UITextField!
    
    
    
    
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let email = username_textfield_register.text, !email.isEmpty else {
            showWarning(message: "Please give a valid email address")
            return
        }
        
        guard let password = username_textfield_register.text, !password.isEmpty else {
            showWarning(message: "Please fill in a password")
            return
        }
        
        if !validateEmail(enteredEmail: email) {
            showWarning(message: "Please give a valid email address")
            return
        }
        
        if password_textfield_register.text != password2_textfield_register.text {
            showWarning(message: "Passwords don't match")
            return
        }
        
        
        if password_textfield_register.text!.count < 6 {
            showWarning(message: "Password shoud be 6 or more characters")
            return
        }
        
        register()
    }
    
    
    func showWarning(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    
    func register() {
        //The ! after String is needed because .text returns a String?
        let email: String! = self.username_textfield_register.text
        let password: String! = self.password_textfield_register.text
        
        //SOURCE: https://firebase.google.com/docs/auth/ios/password-auth
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                self.addUserToDatabase()
                self.performSegue(withIdentifier: "showShoppingListView", sender: self)

            } else {
                print("Error creating user!")
            }
        }
    }
    
    
    func addUserToDatabase() {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let items = [String]()
        let name = userID

        //SOURCE: https://firebase.google.com/docs/firestore/manage-data/add-data
        db.collection("users").document(userID).setData([
            "items": items,
            "name": name
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

