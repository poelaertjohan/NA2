//
//  ShoppingListViewController.swift
//  Shopping List
//
//  Created by johan poelaert on 17/11/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//



import UIKit
import CoreData

class ShoppingListViewController: UITableViewController {
    
    @IBOutlet var shoppingListTableView: UITableView!
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        loadData()
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
        let cellIdentifier = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = itemArray[indexPath.row]
        //let urlKey = item.picture
        
        
        /*
        if let url = URL(string: urlKey) {
            do {
                let data = try Data(contentsOf: url)
                cell.pictureImageView.image = UIImage(data: data)
            } catch let err {
                print(err)
            }
        }
 */
        
        cell.nameLabel.text = item.name
        cell.amountLabel.text = "Amount: " + String(item.amount)
        
        return cell
    }
    
    
    func loadData() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
           let items = try PersistenceService.context.fetch(fetchRequest)
            self.itemArray = items
            self.tableView.reloadData()
        } catch {}
        
        
    }
}



