//
//  ShoppingListViewController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//



import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class ShoppingListViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        loadData()
    }
    
    

    
    func loadData() {
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        print(userID)
        

        
         userRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ data in
                    print(data)
                    //var t: User = User(items: data)
                })
            }) {
                print("User: \(user)")
            } else {
                print("Document does not exist")
            }
        }
 
        
        /*
         //Get every user
        db.collection("users").document(userID) { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                print("gedaan")
            }
        }
        
        */

        
        
        

        
        
    }
}
