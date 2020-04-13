//
//  DatabaseManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Protocol
protocol DocumentSerializable {
    init?(dictionary: [String:Any])
}

class DatabaseManager {
    
    //MARK: - About review
    struct Review {
        var name: String
        var content: String
        var uid: String
        var timeStamp: Date
        
        var dictionary: [String:Any] {
            return [
                NavigationCases.Review.name.rawValue: name,
                NavigationCases.Review.content.rawValue: content,
                NavigationCases.Review.uid.rawValue: uid,
                NavigationCases.Review.timeStamp.rawValue: timeStamp
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
                NavigationCases.Product.productName.rawValue: productName,
                NavigationCases.Product.productPrice.rawValue: productPrice,
                NavigationCases.Product.productDescription.rawValue: productDescription,
                NavigationCases.Product.productCategory.rawValue: productCategory,
                NavigationCases.Product.stock.rawValue: stock
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
                NavigationCases.UsersInfo.totalPrice.rawValue: totalPrice,
                NavigationCases.UsersInfo.name.rawValue: name,
                NavigationCases.UsersInfo.adress.rawValue: adress,
                NavigationCases.UsersInfo.cellphone.rawValue: cellphone,
                NavigationCases.UsersInfo.feedbackOption.rawValue: feedbackOption,
                NavigationCases.UsersInfo.mark.rawValue: mark,
                NavigationCases.UsersInfo.timeStamp.rawValue: timeStamp,
                NavigationCases.UsersInfo.currentDeviceID.rawValue: currentDeviceID,
                NavigationCases.UsersInfo.deliveryPerson.rawValue: deliveryPerson
            ]
        }
    }

}

//MARK: - Extension

//MARK: Про чат
extension DatabaseManager.Review: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[NavigationCases.Review.name.rawValue] as? String,
            let content = dictionary[NavigationCases.Review.content.rawValue] as? String,
            let uid = dictionary[NavigationCases.Review.uid.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.Review.timeStamp.rawValue] as? Timestamp)?.dateValue() else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}

//MARK: Про Продукт
extension DatabaseManager.ProductInfo: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[NavigationCases.Product.productName.rawValue] as? String,
            let productPrice = dictionary[NavigationCases.Product.productPrice.rawValue] as? Int,
            let productDescription = dictionary[NavigationCases.Product.productDescription.rawValue] as? String,
            let productCategory = dictionary[NavigationCases.Product.productCategory.rawValue] as? String,
            let stock = dictionary[NavigationCases.Product.stock.rawValue] as? Bool else {return nil}
        self.init(productName: productName, productPrice: productPrice, productDescription: productDescription, productCategory: productCategory, stock: stock)
    }
}

//MARK: Про Заказ
extension DatabaseManager.Order: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let totalPrice = dictionary[NavigationCases.UsersInfo.totalPrice.rawValue] as? Int64,
            let userName = dictionary[NavigationCases.UsersInfo.name.rawValue] as? String,
            let userAdress = dictionary[NavigationCases.UsersInfo.adress.rawValue] as? String,
            let userCellphone = dictionary[NavigationCases.UsersInfo.cellphone.rawValue] as? String,
            let feedbackOption = dictionary[NavigationCases.UsersInfo.feedbackOption.rawValue] as? String,
            let userMark = dictionary[NavigationCases.UsersInfo.mark.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.UsersInfo.timeStamp.rawValue] as? Timestamp)?.dateValue(),
            let currentDeviceID = dictionary[NavigationCases.UsersInfo.currentDeviceID.rawValue] as? String,
        let deliveryPerson = dictionary[NavigationCases.UsersInfo.deliveryPerson.rawValue] as? String else {return nil}
        self.init(totalPrice: totalPrice, name: userName, adress: userAdress, cellphone: userCellphone, feedbackOption: feedbackOption, mark: userMark, timeStamp: timeStamp, currentDeviceID: currentDeviceID, deliveryPerson: deliveryPerson)
    }
}

