//
//  CartEntity+CoreDataProperties.swift
//  
//
//  Created by Andrew Matsota on 20.03.2020.
//
//

import Foundation
import CoreData


extension CartEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartEntity> {
        return NSFetchRequest<CartEntity>(entityName: "CartEntity")
    }

    @NSManaged public var bill: Int64

}
