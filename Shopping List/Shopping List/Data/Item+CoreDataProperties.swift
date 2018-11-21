//
//  Item+CoreDataProperties.swift
//  
//
//  Created by johan poelaert on 21/11/2018.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Int16
    @NSManaged public var isChecked: Bool

}
