//
//  AddItemController.swift
//  Shopping List
//
//  Created by johan poelaert on 21/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase

class AddItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var name_textfield_addItem: UITextField!
    @IBOutlet weak var amount_textfield_addItem: UITextField!
    @IBOutlet weak var picture_button_addItem: BorderButton!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    var isImageSelected: Bool = false
    let repository = Repository.itemRepository
    
    
    @IBAction func loadPictureClicked(_ sender: Any) {
        openPhotoLibrary()
    }
    
   
    @IBAction func saveClicked(_ sender: Any) {

        guard let name = name_textfield_addItem.text, !name.isEmpty else {
            showWarning(message: "Please pick a valid name")
            return
        }
        
        guard let amount = name_textfield_addItem.text, !amount.isEmpty else {
            showWarning(message: "Please insert a valid amount")
            return
        }
        
        if isImageSelected {
            uploadImage(image: self.selectedImage)
        } else {
            addItemWithoutImage()
        }
        
        name_textfield_addItem.text = ""
        amount_textfield_addItem.text = ""
        selectedImage = UIImage()
    }
    
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    //SOURCE: source weet ik niet meer maak ik heb op het internet gevonden dat deze methode nodig is.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = pickedImage
            isImageSelected = true
        }
 
        dismiss(animated: true, completion: nil)
    }
    
    func showWarning(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
        isImageSelected = false
    }
    
    
    func uploadImage(image: UIImage) {
        repository.addItemAndImage(image: image, name: name_textfield_addItem.text!, amount: amount_textfield_addItem.text!)
    }
    
    func addItemWithoutImage() {
        let im: Item = Item(name: name_textfield_addItem.text!, amount: amount_textfield_addItem.text!, picture: "/", pictureName: "/")
        repository.putItemInDatabase(item: im)
    }
    
}
