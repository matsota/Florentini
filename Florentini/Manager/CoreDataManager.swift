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
    let device = UIDevice.current
    
    //MARK: - Создание заказа/Добавление к заказу
    func saveForCart(name: String, category: String, price: Int64, quantity: Int64) {
        let preOrder = PreOrderEntity(context: PersistenceService.context)
        preOrder.productName = name
        preOrder.productCategory = category
        preOrder.productPrice = price
        preOrder.productQuantity = quantity
        PersistenceService.saveContext()
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
    
    func deleteFromCart(deleteWhere: [NSManagedObject], at indexPath: IndexPath) {
        let certainPosition = indexPath.row
        
        PersistenceService.context.delete(deleteWhere[certainPosition])
        do {
            try PersistenceService.context.save()
        } catch {
            print("CoreData Saving Error")
        }
    }
    
    func deleteAllData(entity: String, success: @escaping() -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try PersistenceService.context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                PersistenceService.context.delete(managedObjectData)
                PersistenceService.saveContext()
            }
            success()
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
        
    }
}
