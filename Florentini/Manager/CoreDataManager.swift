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
    let device = UIDevice.current.identifierForVendor
    
    //MARK: - Создание заказа/Добавление к заказу
    func saveForCart(name: String, category: String, price: Int, quantity: Int, stock: Bool, imageData: NSData, success: @escaping() -> Void, failure: @escaping() -> Void) {
        
        if imageData.isEmpty || name.isEmpty || category.isEmpty || price == 0 || quantity == 0  {
            failure()
        }else{
            let preOrder = PreOrderEntity(context: PersistenceService.context)

            preOrder.productName = name
            preOrder.productCategory = category
            preOrder.productPrice = Int64(price)
            preOrder.productQuantity = Int64(quantity)
            preOrder.stock = stock
            preOrder.productImage = imageData
            PersistenceService.saveContext()
            success()
        }
    }
    
    //MARK: - Сохранить ИД клиента для поиска деталей его заказов
    func saveOrderPath(orderPath: String) {
        let path = OrderDetailPathEntity(context: PersistenceService.context)
        path.path = orderPath
        PersistenceService.saveContext()
    }
    
    //MARK: - Достать ИД Клиента
    @objc func fetchOrderPath(success: @escaping([OrderDetailPathEntity]) -> (Void)) {
        let fetchRequest: NSFetchRequest<OrderDetailPathEntity> = OrderDetailPathEntity.fetchRequest()
        
        do {
            let result = try PersistenceService.context.fetch(fetchRequest)
            success(result)
        } catch {
            print("CoreData Fetch Error")
        }
    }
    
    //MARK: - Обновление количества продукта к Заказу
    func updateCart(name: String, quantity: Int) {
        guard let preOrderEntity = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        if preOrderEntity.count > 0 {
            for currentOrder in preOrderEntity as [NSManagedObject] {
                if name == currentOrder.value(forKey: NavigationCases.ProductCases.productName.rawValue) as! String{
                    currentOrder.setValuesForKeys([NavigationCases.ProductCases.productQuantity.rawValue: Int64(quantity)])
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
    
    //MARK: - Удаление из Cart
    func deleteFromCart(deleteWhere: [NSManagedObject], at indexPath: IndexPath) {
        let certainPosition = indexPath.row
        PersistenceService.context.delete(deleteWhere[certainPosition])
        
        do {
            try PersistenceService.context.save()
        } catch {
            print("CoreData Saving Error")
        }
    }
    //MARK: - Удаление всего заказа
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
