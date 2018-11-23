//
//  Repository.swift
//  Shopping List
//
//  Created by johan poelaert on 22/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class Repository {
    var itemArray = [Item]()
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()

    func getItems() -> [Item] {
        db.collection("users").whereField("name", isEqualTo: userID).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    
                    let items = document.get("items") as! [[String:Any]]
                    
                    
                    for val in items {
                        var amount: Int = 0
                        var isChecked: Bool = false
                        var name: String = ""
                        var picture: String = ""
                        
                        for item in val {
                            if item.key == "amount" {
                                amount = item.value as! Int
                            } else if item.key == "checked" {
                                isChecked = item.value as! Bool
                            } else if item.key == "name" {
                                name = item.value as! String
                            } else if item.key == "picture" {
                                picture = item.value as! String
                            }
                        }
                        self.itemArray.append(Item(name: name, amount: amount, picture: picture, isChecked: isChecked))
                    }
                    
                }
            }
        }
        return itemArray
    }
    
    //returns link to image
    func addItemToDatabase(image: UIImage, name: String, amount: Int, isChecked: Bool) -> String {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageName = NSUUID().uuidString
        var imageLink: String = ""
        let imageReference = storageReference.child("images/").child(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let upload = imageReference.putData(imageData, metadata: metadata) { (metadata, error) in
                if error == nil {
                    let imageRef = storageReference.child("images/"+imageName)
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error)
                        } else {
                            imageLink = url!.absoluteString
                            
                            
                            let newItem = Item(name: name, amount: amount, picture: imageLink, isChecked: isChecked)
                            //add user here
                            self.itemArray.append(newItem)
                            self.putItemInDatabase(item: newItem)
                        }
                    }
                }
            }
        }
        return imageLink
    }
    
    
    func putItemInDatabase(item: Item) {
        let itemString: String = item.name + ";" + String(item.amount) + ";" + item.picture + ";" + String(item.isChecked)
        
        let ref = db.collection("users").document(userID)
        
        ref.updateData([
            "items": FieldValue.arrayUnion([itemString])
            ])
        
    }
}
