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
        var stock: Bool
        
        var dictionary: [String:Any]{
            return [
                DatabaseManager.ProductCases.productName.rawValue: productName,
                DatabaseManager.ProductCases.productPrice.rawValue: productPrice,
                DatabaseManager.ProductCases.productDescription.rawValue: productDescription,
                DatabaseManager.ProductCases.productCategory.rawValue: productCategory,
                DatabaseManager.ProductCases.stock.rawValue: stock
            ]
        }
    }
    
    //MARK: - Шаблон Про Заказ
    struct Order {
        var totalPrice: Int64
        var name: String
        var adress: String
        var cellphone: String
        var feedbackOption: String
        var mark: String
        var timeStamp: Date
        var deviceID: String
        
        var dictionary: [String:Any]{
            return [
                DatabaseManager.UsersInfoCases.totalPrice.rawValue: totalPrice,
                DatabaseManager.UsersInfoCases.name.rawValue: name,
                DatabaseManager.UsersInfoCases.adress.rawValue: adress,
                DatabaseManager.UsersInfoCases.cellphone.rawValue: cellphone,
                DatabaseManager.UsersInfoCases.feedbackOption.rawValue: feedbackOption,
                DatabaseManager.UsersInfoCases.mark.rawValue: mark,
                DatabaseManager.UsersInfoCases.timeStamp.rawValue: timeStamp,
                DatabaseManager.UsersInfoCases.deviceID.rawValue: deviceID
            ]
        }
    }
    
    //MARK: Про детализацию заказа
    struct OrderAddition {
        var productCategory: String
        var productName: String
        var stock: Bool
        var productPrice: Int
        var productQuantity: Int

        var dictionary: [String:Any]{
            return [
                DatabaseManager.ProductCases.productCategory.rawValue: productCategory,
                DatabaseManager.ProductCases.productName.rawValue: productName,
                DatabaseManager.ProductCases.stock.rawValue: stock,
                DatabaseManager.ProductCases.productPrice.rawValue: productPrice,
                DatabaseManager.ProductCases.productQuantity.rawValue: productQuantity
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
extension DatabaseManager.ChatMessages: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[DatabaseManager.MessagesCases.name.rawValue] as? String,
            let content = dictionary[DatabaseManager.MessagesCases.content.rawValue] as? String,
            let uid = dictionary[DatabaseManager.MessagesCases.uid.rawValue] as? String,
            let timeStamp = (dictionary[DatabaseManager.MessagesCases.timeStamp.rawValue] as? Timestamp)?.dateValue() else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}

//MARK: Про Продукт
extension DatabaseManager.ProductInfo: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[DatabaseManager.ProductCases.productName.rawValue] as? String,
            let productPrice = dictionary[DatabaseManager.ProductCases.productPrice.rawValue] as? Int,
            let productDescription = dictionary[DatabaseManager.ProductCases.productDescription.rawValue] as? String,
            let productCategory = dictionary[DatabaseManager.ProductCases.productCategory.rawValue] as? String,
            let stock = dictionary[DatabaseManager.ProductCases.stock.rawValue] as? Bool else {return nil}
        self.init(productName: productName, productPrice: productPrice, productDescription: productDescription, productCategory: productCategory, stock: stock)
    }
}

//MARK: Про Заказ
extension DatabaseManager.Order: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let totalPrice = dictionary[DatabaseManager.UsersInfoCases.totalPrice.rawValue] as? Int64,
            let userName = dictionary[DatabaseManager.UsersInfoCases.name.rawValue] as? String,
            let userAdress = dictionary[DatabaseManager.UsersInfoCases.adress.rawValue] as? String,
            let userCellphone = dictionary[DatabaseManager.UsersInfoCases.cellphone.rawValue] as? String,
            let feedbackOption = dictionary[DatabaseManager.UsersInfoCases.feedbackOption.rawValue] as? String,
            let userMark = dictionary[DatabaseManager.UsersInfoCases.mark.rawValue] as? String,
            let timeStamp = (dictionary[DatabaseManager.UsersInfoCases.timeStamp.rawValue] as? Timestamp)?.dateValue(),
            let deviceID = dictionary[DatabaseManager.UsersInfoCases.deviceID.rawValue] as? String else {return nil}
        self.init(totalPrice: totalPrice, name: userName, adress: userAdress, cellphone: userCellphone, feedbackOption: feedbackOption, mark: userMark, timeStamp: timeStamp, deviceID: deviceID)
    }
}

//MARK: Про детализацию заказа
extension DatabaseManager.OrderAddition: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productCategory = dictionary[DatabaseManager.ProductCases.productCategory.rawValue] as? String,
            let productName = dictionary[DatabaseManager.ProductCases.productName.rawValue] as? String,
            let stock = dictionary[DatabaseManager.ProductCases.stock.rawValue] as? Bool,
            let productPrice = dictionary[DatabaseManager.ProductCases.productPrice.rawValue] as? Int,
            let productQuantity = dictionary[DatabaseManager.ProductCases.productQuantity.rawValue] as? Int else {return nil}
        self.init(productCategory: productCategory, productName: productName, stock: stock, productPrice: productPrice, productQuantity: productQuantity)
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
    
    //MARK: Про пользоватей
    enum UsersInfoCases: String, CaseIterable {
        case totalPrice
        case name
        case adress
        case cellphone
        case feedbackOption
        case mark
        case timeStamp
        case deviceID
        
        case PreOrderEntity
        case cart
        case order
        case orderDescription
        
        case review
    }
    
    //MARK: Про Сообщения
    enum MessagesCases: String, CaseIterable {
        case name
        case content
        case uid
        case timeStamp
        case workers
        case workersMessages
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
        case stock
    }
    
    //MARK: Про категории товара
    enum ProductCategoriesCases: String, CaseIterable {
        case none = "Без Категории"
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
        case stock = "Акции"
    }
    
    //MARK: Про количество
    enum MaxQuantityByCategoriesCases: Int {
        case towHundred = 200
        //        case hundredAndHalf = 150
        case hundred = 100
        //        case halfHundred = 50
        case five = 5
        case three = 3
    }
    
    //MARK: Про обратную связь
    enum FeedbackTypesCases: String, CaseIterable {
        case cellphone = "По телефону"
        case viber = "Viber"
        case telegram = "Telegram"
    }
    
}
