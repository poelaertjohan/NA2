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
    @IBOutlet weak var picture_imageview_addItem: UIImageView!
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        
    }
    
    
    @IBAction func loadPictureClicked(_ sender: Any) {
        openPhotoLibrary()
        
    }
    
    @IBAction func addItemClicked(_ sender: Any) {
        uploadImage()
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
            picture_imageview_addItem.contentMode = .scaleAspectFit
            picture_imageview_addItem.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    
    func uploadImage() {
        Repository().addItemToDatabase(image: self.picture_imageview_addItem.image!, name: name_textfield_addItem.text!, amount: Int(amount_textfield_addItem.text!)!, isChecked: false)
    }
    
}
