//
//  CoreDataManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 17.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func savePrice(value: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "FlorentiniEntity", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(value, forKey: DatabaseManager.ProductCases.productPrice.rawValue)
            do {
                try context.save()
            } catch {
                print("CoreData Saving Error")
            }
        }
    }
    
//    func delPrice(value: Int) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//
//            guard let entityDescription = NSEntityDescription.entity(forEntityName: "FlorentiniEntity", in: context) else {return}
//
//            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
//            newValue.setValue(value, forKey: DatabaseManager.ProductCases.productPrice.rawValue)
//            do {
//                try context.delete(.self())
//            } catch {
//                print("CoreData Saving Error")
//            }
//        }
//    }
    
    func fetchPrices(success: @escaping([FlorentiniEntity]) -> (Void)) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<FlorentiniEntity>(entityName: "FlorentiniEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                success(results)
//                for result in results {
////                    let productPrice = Int(result.productPrice)
////                    print(productPrice)
//                    
//                }
            } catch {
                print("CoreData Fetch Error")
            }
        }
    }
}