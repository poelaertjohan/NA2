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


class RegisterController: UIViewController {
    
    @IBOutlet weak var username_textfield_register: UITextField!
    @IBOutlet weak var password_textfield_register: UITextField!
    @IBOutlet weak var register_button_register: UIButton!
    
    
    @IBAction func registerClicked(_ sender: Any) {
        register()
    }
    
    
    func register() {
        
        //The ! after String is needed because .text returns a String?
        let email: String! = self.username_textfield_register.text
        let password: String! = self.password_textfield_register.text
        
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
        let items = [Item]()

        // Add a new document in collection "cities"
        db.collection("users").document(userID).setData([
            "items": items
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
}

