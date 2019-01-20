//
//  BorderButton.swift
//  Shopping List
//
//  Created by johan poelaert on 24/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit

class BorderButton: UIButton {
    
    //this gets called when object is created
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        layer.cornerRadius = 4
    }
}
