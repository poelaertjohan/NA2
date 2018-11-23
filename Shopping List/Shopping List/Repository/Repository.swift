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
                    
                    let items = document.get("items") as! [String]
                    
                    
                    for val in items {
                        let itemArr = val.components(separatedBy: ";")
                        let name: String = itemArr[0]
                        let amount: Int? = Int(itemArr[1])
                        let picture: String = itemArr[2]
                        let isChecked: Bool? = (itemArr[3] == "true")
                        
                        let item = Item(name: name, amount: amount!, picture: picture, isChecked: isChecked!)
                        
                        self.itemArray.append(item)
                        //print(self.itemArray)
                    }
                }
            }
            //na deze regel is itemarray leeg
            print(self.itemArray.count)
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
