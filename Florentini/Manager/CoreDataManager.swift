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
   
    //MARK: - Создание заказа/Добавление к заказу
    func saveForCart(name: String, category: String, price: Int64, quantity: Int64) {
        let preOrder = PreOrderEntity(context: PersistenceService.context)
        preOrder.productName = name
        preOrder.productCategory = category
        preOrder.productPrice = price
        preOrder.productQuantity = quantity
        PersistenceService.saveContext()
        print("savedForCart")
    }
    
    //MARK: - Обновление количества продукта к Заказу
    func updateCart(name: String, quantity: Int64) {
        guard let preOrderEntity = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        if preOrderEntity.count > 0 {
            for currentOrder in preOrderEntity as [NSManagedObject] {
                if name == currentOrder.value(forKey: DatabaseManager.ProductCases.productName.rawValue) as! String{
                    currentOrder.setValuesForKeys([DatabaseManager.ProductCases.productQuantity.rawValue: quantity])
                    PersistenceService.saveContext()
                }
            }
        }
//        PersistenceService.saveContext()
    }
    
    //MARK: - Custom Core Data Saving support
    @objc func fetchPreOrder(success: @escaping([PreOrderEntity]) -> (Void)) {
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
            //                PersistenceService.context.delete(preOrder.)
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
    
    
}
