//
//  PreOrderEntity+CoreDataClass.swift
//  
//
//  Created by Andrew Matsota on 20.03.2020.
//
//

import Foundation
import CoreData

@objc(PreOrderEntity)
public class PreOrderEntity: NSManagedObject {

    
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        for attribute in entity.attributesByName {
            if let value = value(forKey: attribute.key) {
                dict[attribute.key] = value
            }
        }
        
        return dict
    }
}
