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
import FirebaseStorage

class ItemRepository {
    var itemArray = [Item]()
    let db = Firestore.firestore()
    let dispatchGroup = DispatchGroup()
    
    func getItemArray() -> [Item] {
        return itemArray
    }
    
    func addItemToArray(item: Item) {
        itemArray.append(item)
    }
    
    func setItemArray(array: [Item]) {
        self.itemArray = array
    }
    
    func clearItemArray() {
        self.itemArray = [Item]()
    }
    
    //returns link to image
    func addItemAndImage(image: UIImage, name: String, amount: String) -> DispatchGroup {
        dispatchGroup.enter()
        disableInteraction(true)
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageName = NSUUID().uuidString
        var imageLink: String = ""
        let imageReference = storageReference.child("images/").child(imageName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            imageReference.putData(imageData, metadata: metadata) { (metadata, error) in
                if error == nil {
                    let imageRef = storageReference.child("images/"+imageName)
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error)
                        } else {
                            imageLink = url!.absoluteString
                            
                            
                            let newItem = Item(name: name, amount: amount, picture: imageLink, pictureName: imageName)
                            
                            self.putItemInDatabase(item: newItem)
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        return self.dispatchGroup
    }
    
    //SOURCE: https://firebase.google.com/docs/firestore/manage-data/add-data
    func putItemInDatabase(item: Item) -> DispatchGroup {
        dispatchGroup.enter()
        let userID = Auth.auth().currentUser!.uid
        let itemString: String = convertItemToString(item: item)
        
        let ref = db.collection("users").document(userID)
        
        ref.updateData([
            "items": FieldValue.arrayUnion([itemString])
            ])
        addItemToArray(item: item)
        disableInteraction(false)
        dispatchGroup.leave()
        return dispatchGroup
    }
    
    func updateItemsInDatabase(itemArray: [Item]) {
        
        let userID = Auth.auth().currentUser!.uid
        var itemsInString = [String]()
        for item in itemArray {
            itemsInString.append(convertItemToString(item: item))
        }
        
        db.collection("users").document(userID).updateData([
            "items": itemsInString
            ])
    }
    
    //SOURCE: https://firebase.google.com/docs/firestore/manage-data/delete-data
    func deleteItemFromStorage(folderName: String, itemName: String) {
        Storage.storage().reference().child(folderName + itemName).delete { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func convertItemToString(item: Item) -> String {
        return item.name + ";" + String(item.amount) + ";" + item.picture + ";" + item.pictureName
    }
    
    
    func disableInteraction(_ disable: Bool) {
        if disable {
            UIApplication.shared.beginIgnoringInteractionEvents()
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
