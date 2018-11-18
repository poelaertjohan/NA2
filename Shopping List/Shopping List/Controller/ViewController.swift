//
//  ViewController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "showShoppingListView", sender: self)
        }
    }
    
    
}

