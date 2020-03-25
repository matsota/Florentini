//
//  DatabaseManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    //MARK: - Системные переменные
    static let shared = DatabaseManager()
    
    //MARK: - Шаблон для информации о Сотруднике
    struct WorkerInfo {
        var name: String
        var position: String
        
        var dictionary: [String:Any]{
            return [
                DatabaseManager.WorkerInfoCases.name.rawValue: name,
                DatabaseManager.WorkerInfoCases.position.rawValue: position
            ]
        }
    }
    
    //MARK: - Шаблон для информации о Чате
    struct ChatMessages {
        var name: String
        var content: String
        var uid: String
        var timeStamp: Date
        
        var dictionary: [String:Any] {
            return [
                DatabaseManager.MessagesCases.name.rawValue: name,
                DatabaseManager.MessagesCases.content.rawValue: content,
                DatabaseManager.MessagesCases.uid.rawValue: uid,
                DatabaseManager.MessagesCases.timeStamp.rawValue: timeStamp
            ]
        }
    }
    
    //MARK: - Шаблон Про Продукт (закачка)
    struct ProductInfo {
        var productName: String
        var productPrice: Int
        var productDescription: String
        var productCategory: String
        
        var dictionary: [String:Any]{
            return [
                DatabaseManager.ProductCases.productName.rawValue: productName,
                DatabaseManager.ProductCases.productPrice.rawValue: productPrice,
                DatabaseManager.ProductCases.productDescription.rawValue: productDescription,
                DatabaseManager.ProductCases.productCategory.rawValue: productCategory
            ]
        }
    }
    
    //MARK: - Шаблон Про Неподтвержденный Продукт
    struct PreOrder {
        var productName: String
        var productPrice: Int
        var productCategory: String
        
        var dictionary: [String:Any]{
            return [
                DatabaseManager.ProductCases.productName.rawValue: productName,
                DatabaseManager.ProductCases.productPrice.rawValue: productPrice,
                DatabaseManager.ProductCases.productCategory.rawValue: productCategory
            ]
        }
    }
    
    
    //MARK: - Шаблон Про Неподтвержденный Продукт
       struct PreOrderCorrection {

           var productPrice: Int
           
           var dictionary: [String:Any]{
               return [
                   DatabaseManager.ProductCases.productPrice.rawValue: productPrice,
               ]
           }
       }
    
    
}

//MARK: - OUT of Class
//MARK: - Протокол шаблонов
protocol DocumentSerializable {
    init?(dictionary: [String:Any])
}


//MARK: - Extensions Init
//MARK: О сотрудниках
extension DatabaseManager.WorkerInfo: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary[DatabaseManager.WorkerInfoCases.name.rawValue] as? String,
            let position = dictionary[DatabaseManager.WorkerInfoCases.position.rawValue] as? String else {return nil}
        self.init(name: name, position: position)
    }
}

//MARK: Про чат
extension DatabaseManager.ChatMessages: DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[DatabaseManager.MessagesCases.name.rawValue] as? String,
            let content = dictionary[DatabaseManager.MessagesCases.content.rawValue] as? String,
            let uid = dictionary[DatabaseManager.MessagesCases.uid.rawValue] as? String,
            let timeStamp = (dictionary[DatabaseManager.MessagesCases.timeStamp.rawValue] as? Timestamp)?.dateValue() else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}

//MARK: Про Продукт (закачка)
extension DatabaseManager.ProductInfo: DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[DatabaseManager.ProductCases.productName.rawValue] as? String,
            let productPrice = dictionary[DatabaseManager.ProductCases.productPrice.rawValue] as? Int,
            let productDescription = dictionary[DatabaseManager.ProductCases.productDescription.rawValue] as? String,
            let productCategory = dictionary[DatabaseManager.ProductCases.productCategory.rawValue] as? String else {return nil}
        self.init(productName: productName, productPrice: productPrice, productDescription: productDescription, productCategory: productCategory)
    }
}

//MARK: Про Неподтвержденный Продукт (закачка)
extension DatabaseManager.PreOrder: DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[DatabaseManager.ProductCases.productName.rawValue] as? String,
            let productPrice = dictionary[DatabaseManager.ProductCases.productPrice.rawValue] as? Int,
            let productCategory = dictionary[DatabaseManager.ProductCases.productCategory.rawValue] as? String else {return nil}
        self.init(productName: productName, productPrice: productPrice, productCategory: productCategory)
    }
}

//MARK: Про Неподтвержденный Продукт (коррекция)
extension DatabaseManager.PreOrderCorrection: DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let productPrice = dictionary[DatabaseManager.ProductCases.productPrice.rawValue] as? Int else {return nil}
        self.init(productPrice: productPrice)
    }
}

//MARK: - Cases Extension
extension DatabaseManager {
    //MARK: Про сотрудников
    enum WorkerInfoCases: String, CaseIterable {
        case name
        case position
        case admin
        case `operator`
        case delivery
    }
    //MARK: Про Сообщения
    enum MessagesCases: String, CaseIterable {
        case name
        case content
        case uid
        case timeStamp
        case workers
        case workersMessages
        case review
        
    }
    
    //MARK: Про Товар
    enum ProductCases: String, CaseIterable {
        case productName
        case productPrice
        case productQuantity
        case productCategory
        case productDescription
        case productImageURL
        case imageCollection
        case preOrder
        case preOrderCorrection
        case cart
    }
    
    enum ProductCategoriesCases: String, CaseIterable {
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
        case stock = "Акции"
//        case stockApice = "Акция Поштучно"
//        case stockBouquet = "Акция Букет"
    }
    
    enum NonCategory: String, CaseIterable {
            case none = "Без Категории"
        }
    enum MaxQuantityByCategoriesCases: Int {
        case towHundred = 200
//        case hundredAndHalf = 150
        case hundred = 100
//        case halfHundred = 50
        case five = 5
        case three = 3
    }
    enum FeedbackTypesCases: String, CaseIterable {
        case cellphone = "По телефону"
        case viber = "Viber"
        case telegram = "Telegram"
    }
    
}
