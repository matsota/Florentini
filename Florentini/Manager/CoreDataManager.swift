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
    var preOrder = [PreOrderEntity]()

    func saveForCart(name: String, category: String, price: Int64, quantity: Int64, complition: () -> Void) {
        let preOrder = PreOrderEntity(context: PersistenceService.context)
        preOrder.productName = name
        preOrder.productCategory = category
        preOrder.productPrice = price
        preOrder.productQuantity = quantity
        PersistenceService.saveContext()
        print("SAVED BABY Woohoo!")
        }
    
    //MARK: - Custom Core Data Saving support
    func fetchPreOrder(success: @escaping([PreOrderEntity]) -> (Void)) {
        let fetchRequest: NSFetchRequest<PreOrderEntity> = PreOrderEntity.fetchRequest()
        do {
            let result = try PersistenceService.context.fetch(fetchRequest)
            success(result)
        } catch {
            print("CoreData Fetch Error")
        }
        
    }

    
    func deleteFromCart(name: String, category: String, price: Int64, quantity: Int64) {
//        let context = PreOrderEntity(context: PersistenceService.context)
//            context.productCategory = category
//            context.productPrice = price
//            context.productQuantity = quantity
        
            do {
//                PersistenceService.context.delete(name)
//                PersistenceService.context.delete(category)
//                PersistenceService.context.delete(price)
//                PersistenceService.context.delete(quantity)
                try PersistenceService.context.save()
            } catch {
                print("CoreData Saving Error")
            }
    }
//    
//    func deleteFromCart(quantity: Int) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//            guard let entityDescription = NSEntityDescription.entity(forEntityName: "PreOrderEntity", in: context) else {return}
//            let newQuantity = NSManagedObject(entity: entityDescription, insertInto: context)
//            
//            do {
//                context.delete(newQuantity)
//                try context.save()
//            } catch {
//                print("CoreData Saving Error")
//                
//            }
//        }
//    }
    
    //    func deleteCartByUID(quantity: Int) {
    //        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
    //            let context = appDelegate.persistentContainer.viewContext
    //            guard let entityDescription = NSEntityDescription.entity(forEntityName: "PreOrderEntity", in: context) else {return}
    //            let newQuantity = NSManagedObject(entity: entityDescription, insertInto: context)
    //
    //            newQuantity.setValue(quantity, forKey: DatabaseManager.ProductCases.productQuantity.rawValue)
    //            context.delete(newQuantity)
    //            if context.hasChanges{
    //                do {
    //                    try context.save()
    //                } catch {
    //                    print("CoreData Saving Error")
    //                }
    //            }
    //        }
    //    }
    
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
    
//    func fetchPrices(success: @escaping([PreOrderEntity]) -> (Void)) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<PreOrderEntity>(entityName: "PreOrderEntity")
//            
//            do {
//                let orders = try context.fetch(fetchRequest)
//                success(orders)
//                //                for result in results {
//                ////                    let productPrice = Int(result.productPrice)
//                ////                    print(productPrice)
//                //
//                //                }
//                
//            } catch {
//                print("CoreData Fetch Error")
//            }
//        }
//    }
}
