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
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logoutAndShowHome", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    func loadData() {
        let userID = Auth.auth().currentUser!.uid //WluCBFSyFRQNbsc0rOeoNln4XnX2
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        let reference = Firestore.firestore().collection("users")
        
        
        
        db.collection("users").whereField("name", isEqualTo: userID).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    print("voor looooooop")

                    var items = document.get("items") as! [[String:Any]]
                    //var test = items[0][Item]
                    print("na loooooop")
                    var test = items[0]
                    print(test)
                    
                    /*
                    if let array = document.data()["items"]{
                            print("in looooooooop")
                            print(array)
                        }
 */
                    }
                }
            }
 
 
        
        
        /*
         userRef.getDocument { (document, error) in
            var t = document?.data()!["items"]!
            print("documentje")
            print(t)
         if let user = document.flatMap({
         $0.data().flatMap({ (data) in
         
            print("voor cast")
            print(data["items"]!)
         
            let testje: User = User(items: data["items"] as! [Item])
            print("testje")
         })
         }) {
         print("User: \(user)")
         } else {
         print("Document does not exist")
         }
         }
        */
        
        
        
        
        
        /*
        db.collection("users").getDocuments{ (snapshot, err) in
            if let err = err {
                print("error")
            } else {
                for document in snapshot!.documents {
                    if userID == document.documentID {
                        print("in for loop")
                        //print(document.get("items"))
                        var testje: Any = document.get("items")
                        print("testje")
                    }
                }
            }
        }
        */
        
        
        
        
        
        /*
         //get all users
        reference.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
        }
 */
 
        
        
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
