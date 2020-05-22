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
    
    
    ///
    //MARK: - Crud
    ///
    //MARK: - Add to Cart
    func addProduct(name: String, category: String, price: Int, quantity: Int, stock: Bool, imageData: Data, success: @escaping() -> Void, failure: @escaping() -> Void) {
        
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
    
    //MARK: - Save Client Data
    func saveClientInfo(name: String, phone: String, success: @escaping() -> Void, failure: @escaping() -> Void) {
        
        if name.isEmpty || phone.isEmpty {
            failure()
        }else{
            let preOrder = ClientData(context: PersistenceService.context)
            preOrder.name = name
            preOrder.phone = phone
            
            PersistenceService.saveContext()
            success()
        }
    }
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: - Fetch PreOrder
    @objc func fetchPreOrder(success: @escaping([PreOrderEntity]) -> (Void), failure: @escaping(NSError) -> Void) {
        let fetchRequest: NSFetchRequest<PreOrderEntity> = PreOrderEntity.fetchRequest()
        
        do {
            let result = try PersistenceService.context.fetch(fetchRequest)
            success(result)
        } catch let error as NSError{
            failure(error)
        }
    }
    
    @objc func cartIsEmpty(bar: UITabBarItem){
        
        let fetchRequest: NSFetchRequest<PreOrderEntity> = PreOrderEntity.fetchRequest(),
        result = try? PersistenceService.context.fetch(fetchRequest)
        
        if result == [] {
            bar.badgeValue = nil
        }else{
            let count = result!.count
            bar.badgeColor = UIColor.pinkColorOfEnterprise
            bar.badgeValue = "\(count)"
        }
    }
    
    
    //MARK: - Fetch Client Data
    @objc func fetchClientData(success: @escaping([ClientData]) -> (Void), failure: @escaping(NSError) -> Void) {
        let fetchRequest: NSFetchRequest<ClientData> = ClientData.fetchRequest()
        
        do {
            let result = try PersistenceService.context.fetch(fetchRequest)
            success(result)
        } catch let error as NSError{
            failure(error)
        }
    }
    
    //    //MARK: - Only Client's Name
    //    func fetchClientName(failure: @escaping(NSError) -> Void) -> String? {
    //        var name: String?
    //
    //        fetchClientData(success: { (data) -> (Void) in
    //            name = data.map({$0.name!}).first
    //        }) { (error) in
    //            failure(error)
    //        }
    //        return name
    //    }
    //
    //    //MARK: - Only Client's Phone
    //    func fetchClientPhone(failure: @escaping(NSError) -> Void) -> String? {
    //        var phone: String?
    //
    //        fetchClientData(success: { (data) -> (Void) in
    //            phone = data.map({$0.phone!}).first
    //        }) { (error) in
    //            failure(error)
    //        }
    //        return phone
    //    }
    
    ///
    //MARK: - crUd
    ///
    //MARK: - Update product condition in the Cart
    func cartUpdate(name: String, quantity: Int) {
        guard let preOrderEntity = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        if preOrderEntity.count > 0 {
            for currentOrder in preOrderEntity as [NSManagedObject] {
                if name == currentOrder.value(forKey: NavigationCases.Product.productName.rawValue) as? String{
                    currentOrder.setValuesForKeys([NavigationCases.Product.productQuantity.rawValue: Int64(quantity)])
                    PersistenceService.saveContext()
                }
            }
        }
    }
    
    
    ///
    //MARK: - cruD
    ///
    //MARK: - Product dismiss
    func productDismiss(deleteWhere: [NSManagedObject], at indexPath: IndexPath) {
        let certainPosition = indexPath.row
        PersistenceService.context.delete(deleteWhere[certainPosition])
        
        do {
            try PersistenceService.context.save()
        } catch {
            print("CoreData Saving Error")
        }
    }
    
    //MARK: - Order deletion
    func deleteAllData(entity: String, success: @escaping() -> Void, failure: @escaping(NSError) -> Void) {
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
            failure(error)
        }
    }
    
}
