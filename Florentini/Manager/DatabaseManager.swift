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
    struct EmployeeInfo {
        var name: String
        var position: String
        
        var dictionary: [String:Any]{
            return [
                NavigationCases.WorkerInfoCases.name.rawValue: name,
                NavigationCases.WorkerInfoCases.position.rawValue: position
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
                NavigationCases.MessagesCases.name.rawValue: name,
                NavigationCases.MessagesCases.content.rawValue: content,
                NavigationCases.MessagesCases.uid.rawValue: uid,
                NavigationCases.MessagesCases.timeStamp.rawValue: timeStamp
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
                NavigationCases.ProductCases.productName.rawValue: productName,
                NavigationCases.ProductCases.productPrice.rawValue: productPrice,
                NavigationCases.ProductCases.productDescription.rawValue: productDescription,
                NavigationCases.ProductCases.productCategory.rawValue: productCategory,
                NavigationCases.ProductCases.stock.rawValue: stock
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
        var currentDeviceID: String
        var deliveryPerson: String
        
        var dictionary: [String:Any]{
            return [
                NavigationCases.UsersInfoCases.totalPrice.rawValue: totalPrice,
                NavigationCases.UsersInfoCases.name.rawValue: name,
                NavigationCases.UsersInfoCases.adress.rawValue: adress,
                NavigationCases.UsersInfoCases.cellphone.rawValue: cellphone,
                NavigationCases.UsersInfoCases.feedbackOption.rawValue: feedbackOption,
                NavigationCases.UsersInfoCases.mark.rawValue: mark,
                NavigationCases.UsersInfoCases.timeStamp.rawValue: timeStamp,
                NavigationCases.UsersInfoCases.currentDeviceID.rawValue: currentDeviceID,
                NavigationCases.UsersInfoCases.deliveryPerson.rawValue: deliveryPerson
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
                NavigationCases.ProductCases.productCategory.rawValue: productCategory,
                NavigationCases.ProductCases.productName.rawValue: productName,
                NavigationCases.ProductCases.stock.rawValue: stock,
                NavigationCases.ProductCases.productPrice.rawValue: productPrice,
                NavigationCases.ProductCases.productQuantity.rawValue: productQuantity
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

//MARK: Employee
extension DatabaseManager.EmployeeInfo: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary[NavigationCases.WorkerInfoCases.name.rawValue] as? String,
            let position = dictionary[NavigationCases.WorkerInfoCases.position.rawValue] as? String else {return nil}
        self.init(name: name, position: position)
    }
}

//MARK: Про чат
extension DatabaseManager.ChatMessages: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[NavigationCases.MessagesCases.name.rawValue] as? String,
            let content = dictionary[NavigationCases.MessagesCases.content.rawValue] as? String,
            let uid = dictionary[NavigationCases.MessagesCases.uid.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.MessagesCases.timeStamp.rawValue] as? Timestamp)?.dateValue() else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}

//MARK: Про Продукт
extension DatabaseManager.ProductInfo: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[NavigationCases.ProductCases.productName.rawValue] as? String,
            let productPrice = dictionary[NavigationCases.ProductCases.productPrice.rawValue] as? Int,
            let productDescription = dictionary[NavigationCases.ProductCases.productDescription.rawValue] as? String,
            let productCategory = dictionary[NavigationCases.ProductCases.productCategory.rawValue] as? String,
            let stock = dictionary[NavigationCases.ProductCases.stock.rawValue] as? Bool else {return nil}
        self.init(productName: productName, productPrice: productPrice, productDescription: productDescription, productCategory: productCategory, stock: stock)
    }
}

//MARK: Про Заказ
extension DatabaseManager.Order: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let totalPrice = dictionary[NavigationCases.UsersInfoCases.totalPrice.rawValue] as? Int64,
            let userName = dictionary[NavigationCases.UsersInfoCases.name.rawValue] as? String,
            let userAdress = dictionary[NavigationCases.UsersInfoCases.adress.rawValue] as? String,
            let userCellphone = dictionary[NavigationCases.UsersInfoCases.cellphone.rawValue] as? String,
            let feedbackOption = dictionary[NavigationCases.UsersInfoCases.feedbackOption.rawValue] as? String,
            let userMark = dictionary[NavigationCases.UsersInfoCases.mark.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.UsersInfoCases.timeStamp.rawValue] as? Timestamp)?.dateValue(),
            let currentDeviceID = dictionary[NavigationCases.UsersInfoCases.currentDeviceID.rawValue] as? String,
        let deliveryPerson = dictionary[NavigationCases.UsersInfoCases.deliveryPerson.rawValue] as? String else {return nil}
        self.init(totalPrice: totalPrice, name: userName, adress: userAdress, cellphone: userCellphone, feedbackOption: feedbackOption, mark: userMark, timeStamp: timeStamp, currentDeviceID: currentDeviceID, deliveryPerson: deliveryPerson)
    }
}

//MARK: Про детализацию заказа
extension DatabaseManager.OrderAddition: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productCategory = dictionary[NavigationCases.ProductCases.productCategory.rawValue] as? String,
            let productName = dictionary[NavigationCases.ProductCases.productName.rawValue] as? String,
            let stock = dictionary[NavigationCases.ProductCases.stock.rawValue] as? Bool,
            let productPrice = dictionary[NavigationCases.ProductCases.productPrice.rawValue] as? Int,
            let productQuantity = dictionary[NavigationCases.ProductCases.productQuantity.rawValue] as? Int else {return nil}
        self.init(productCategory: productCategory, productName: productName, stock: stock, productPrice: productPrice, productQuantity: productQuantity)
    }
}
