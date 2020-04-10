//
//  PreOrderEntity+CoreDataProperties.swift
//  
//
//  Created by Andrew Matsota on 20.03.2020.
//
//

import Foundation
import CoreData


extension PreOrderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreOrderEntity> {
        return NSFetchRequest<PreOrderEntity>(entityName: "PreOrderEntity")
    }
    
    @NSManaged public var productImage: Data?
    @NSManaged public var productName: String?
    @NSManaged public var productPrice: Int64
    @NSManaged public var productQuantity: Int64
    @NSManaged public var productCategory: String?
    @NSManaged public var stock: Bool

}
