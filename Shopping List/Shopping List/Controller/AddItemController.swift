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
    @IBOutlet weak var picture_button_addItem: UIButton!
    let imagePicker = UIImagePickerController()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        
    }
    
    
    @IBAction func loadPictureClicked(_ sender: Any) {
        openPhotoLibrary()
        
    }
    
    @IBAction func addItemClicked(_ sender: Any) {
        uploadImage(image: self.selectedImage)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = pickedImage
        }
 
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    
    func uploadImage(image: UIImage) {
        Repository().addItemToDatabase(image: image, name: name_textfield_addItem.text!, amount: Int(amount_textfield_addItem.text!)!, isChecked: false)
    }
    
}
