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

    
    //returns link to image
    func addItemToDatabase(image: UIImage, name: String, amount: String) -> String {
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
                            
                            
                            let newItem = Item(name: name, amount: amount, picture: imageLink, pictureName: imageName)
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
        let itemString: String = convertItemToString(item: item)
        
        let ref = db.collection("users").document(userID)
        
        ref.updateData([
            "items": FieldValue.arrayUnion([itemString])
            ])
        
    }
    
    func updateItemsInDatabase(itemArray: [Item]) {
        
        var itemsInString = [String]()
        for item in itemArray {
            itemsInString.append(convertItemToString(item: item))
        }
        
        db.collection("users").document(userID).updateData([
            "items": itemsInString
            ])
    }
    
    func deleteItemFromStorate(folderName: String, itemName: String) {
        Storage.storage().reference().child(folderName + itemName).delete { (error) in
            if let error = error {
                print("can't delete item from storage")
            }
        }
    }
    
    func convertItemToString(item: Item) -> String {
        return item.name + ";" + String(item.amount) + ";" + item.picture + ";" + item.pictureName
    }
    
    
    
}
