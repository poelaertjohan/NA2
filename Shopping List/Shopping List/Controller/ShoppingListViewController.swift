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
import Kingfisher


class ShoppingListViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet var shoppingListTableView: UITableView!
    var itemArray = [Item]()
    let repository = Repository.itemRepository
    let userID = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        super.viewDidLoad()
        self.getItems()
    }
    
    
    
    //SOURCE: https://firebase.google.com/docs/auth/ios/custom-auth
    @IBAction func logoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logoutAndShowHome", sender: self)
            
            //clear list so a user doesn't get another user his items
            self.repository.clearItemArray()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    } 
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.repository.getItemArray().count
    }
    
    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.repository.getItemArray().count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = self.repository.getItemArray()[indexPath.row]
        let urlKey = item.picture
        
        if urlKey != "/" {
            let url = URL(string: urlKey)
            cell.pictureImageView.kf.setImage(with: url)
            //cell.pictureImageView.image = UIImage(named: "cookies")

            /*
            if let url = URL(string: urlKey) {
                do {
                    let data = try Data(contentsOf: url)
                    cell.pictureImageView.image = UIImage(data: data)
                    
                    //Use this for testing so you don't reach firebase quota
                } catch let err {
                    print(err)
                }
            }
 */
        }
        
        
        cell.nameLabel.text = item.name
        cell.amountLabel.text = "Amount: " + String(item.amount)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if repository.getItemArray()[indexPath.row].picture != "/" {
            self.repository.deleteItemFromStorage(folderName: "images/", itemName: self.repository.getItemArray()[indexPath.row].pictureName)
        }
        
        itemArray = self.repository.getItemArray()
        itemArray.remove(at: indexPath.row)
        self.repository.setItemArray(array: itemArray)
        
        tableView.reloadData()
        //tableView.deleteRows(at: [indexPath], with: .automatic)
        
        self.repository.updateItemsInDatabase(itemArray: self.itemArray)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedItem = self.repository.getItemArray()[indexPath.row]
        
        if selectedItem.pictureName != "/" {
        if let url = URL(string: self.repository.getItemArray()[indexPath.row].picture) {
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
        var t = self.repository.getItemArray()
        
        //this way reloadData works faster
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func showImageFullScreen(image:UIImage){
        let fullscreenImage = UIImageView(image: image)
        fullscreenImage.contentMode = .scaleAspectFit
        fullscreenImage.backgroundColor = .black
        fullscreenImage.frame = UIScreen.main.bounds
        fullscreenImage.isUserInteractionEnabled = true
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(self.hideFullscreenImage(_:)))
        fullscreenImage.addGestureRecognizer(tapCell)
        self.view.addSubview(fullscreenImage)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func hideFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    //Data ophalen heb ik van onderstaande source, vanaf regel 164 heb ik zelf geschreven
    //SOURCE: https://firebase.google.com/docs/firestore/query-data/get-data
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
                        self.repository.addItemToArray(item: item)
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}



