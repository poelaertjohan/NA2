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
    
    @IBOutlet var shoppingListTableView: UITableView!
    var itemArray = [Item]()
    let repository = Repository()
    
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        self.itemArray = self.repository.getItems()
        print(itemArray)
        print(itemArray)
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
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemArray.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = itemArray[indexPath.row]
        let urlKey = item.picture
        
        
        
        if let url = URL(string: urlKey) {
            do {
                let data = try Data(contentsOf: url)
                cell.pictureImageView.image = UIImage(data: data)
            } catch let err {
                print(err)
            }
        }
        
        cell.nameLabel.text = item.name
        cell.amountLabel.text = "Amount: " + String(item.amount)
        
        return cell
    }
}



