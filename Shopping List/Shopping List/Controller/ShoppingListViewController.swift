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

class ShoppingListViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet var shoppingListTableView: UITableView!
    var itemArray = [Item]()
    let repository = Repository()
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        self.getItems()
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
    
    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemArray.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = itemArray[indexPath.row]
        let urlKey = item.picture
        
        if urlKey != "/" {
            if let url = URL(string: urlKey) {
                do {
                    let data = try Data(contentsOf: url)
                    cell.pictureImageView.image = UIImage(data: data)
                } catch let err {
                    print(err)
                }
            }
        }
        
        
        cell.nameLabel.text = item.name
        cell.amountLabel.text = "Amount: " + String(item.amount)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if itemArray[indexPath.row].picture != "/" {
            self.repository.deleteItemFromStorate(folderName: "images/", itemName: itemArray[indexPath.row].pictureName)
        }
        
        itemArray.remove(at: indexPath.row)
        
        tableView.reloadData()
        //tableView.deleteRows(at: [indexPath], with: .automatic)
        
        self.repository.updateItemsInDatabase(itemArray: self.itemArray)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedItem = self.itemArray[indexPath.row]
        
        if selectedItem.pictureName != "/" {
        if let url = URL(string: itemArray[indexPath.row].picture) {
            do {
                let data = try Data(contentsOf: url)
                showImageFullScreen(image: UIImage(data: data)!)
            } catch let err {
                print(err)
            }
        }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        let alert = UIAlertController(title: "scherm geladen", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func showImageFullScreen(image:UIImage){
        let fullscreenImage = UIImageView(image: image)
        fullscreenImage.contentMode = .scaleAspectFit
        fullscreenImage.backgroundColor = .black
        fullscreenImage.frame = UIScreen.main.bounds
        fullscreenImage.isUserInteractionEnabled = true
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        fullscreenImage.addGestureRecognizer(tapCell)
        self.view.addSubview(fullscreenImage)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    
    func getItems() {
        db.collection("users").whereField("name", isEqualTo: userID).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    
                    let items = document.get("items") as! [String]
                    
                    
                    var arrayOfItems = [Item]()
                    for val in items {
                        let itemArr = val.components(separatedBy: ";")
                        let name: String = itemArr[0]
                        let amount: String = itemArr[1]
                        let picture: String = itemArr[2]
                        let pictureName: String = itemArr[3]
                        
                        let item = Item(name: name, amount: amount, picture: picture, pictureName: pictureName)
                        
                        arrayOfItems.append(item)
                        //print(self.itemArray)
                    }
                    self.itemArray = arrayOfItems
                    self.tableView.reloadData()
                }
            }
        }
    }
}



