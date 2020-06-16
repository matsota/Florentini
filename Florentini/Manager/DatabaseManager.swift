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
    
    //MARK: - About client
    struct ClientInfo {
        var name: String
        var phone: String
        var orderCount: Int
        var deviceID: String
        var lastAdress: String
        //        var adressesDict: [String:Int]
        //        var productDict: [String:Int]
        
        var dictionary: [String:Any] {
            return [
                NavigationCases.ForClientData.name.rawValue: name,
                NavigationCases.ForClientData.phone.rawValue: phone,
                NavigationCases.ForClientData.orderCount.rawValue: orderCount,
                NavigationCases.ForClientData.deviceID.rawValue: deviceID,
                NavigationCases.ForClientData.lastAdress.rawValue: lastAdress
//                NavigationCases.ForClientData.adressesDict.rawValue: adressesDict,
//                NavigationCases.ForClientData.productDict.rawValue: productDict
            ]
        }
        
    }
    
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
    
    //MARK: - About product info
    struct ProductInfo {
        var productName: String
        var productPrice: Int
        var productDescription: String
        var productCategory: String
        var productSubCategory: String
        var stock: Bool
        var productID: String
        var searchArray: [String]
        var voteCount: Int
        var voteAmount: Int
        
        var dictionary: [String:Any]{
            return [
                NavigationCases.Product.productName.rawValue: productName,
                NavigationCases.Product.productPrice.rawValue: productPrice,
                NavigationCases.Product.productDescription.rawValue: productDescription,
                NavigationCases.Product.productCategory.rawValue: productCategory,
                NavigationCases.Product.productSubCategory.rawValue: productSubCategory,
                NavigationCases.Product.stock.rawValue: stock,
                NavigationCases.Product.productID.rawValue: productID,
                NavigationCases.Product.searchArray.rawValue: searchArray,
                NavigationCases.Product.voteCount.rawValue: voteCount,
                NavigationCases.Product.voteAmount.rawValue: voteAmount
            ]
        }
    }
    
    //MARK: About product filtering
    struct ProductFilter {
        var flower: [String]
        var bouquet: [String]
        var gift: [String]
        
        var dictionary: [String: Any]{
            return [
                NavigationCases.ProductCategories.flower.rawValue: flower,
                NavigationCases.ProductCategories.bouquet.rawValue: bouquet,
                NavigationCases.ProductCategories.gift.rawValue: gift
            ]
            
        }
        
    }
    
    //MARK: - About order
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
        var orderID: String
        
        var dictionary: [String:Any]{
            return [
                NavigationCases.UserInfo.totalPrice.rawValue: totalPrice,
                NavigationCases.UserInfo.name.rawValue: name,
                NavigationCases.UserInfo.adress.rawValue: adress,
                NavigationCases.UserInfo.cellphone.rawValue: cellphone,
                NavigationCases.UserInfo.feedbackOption.rawValue: feedbackOption,
                NavigationCases.UserInfo.mark.rawValue: mark,
                NavigationCases.UserInfo.timeStamp.rawValue: timeStamp,
                NavigationCases.UserInfo.currentDeviceID.rawValue: currentDeviceID,
                NavigationCases.UserInfo.deliveryPerson.rawValue: deliveryPerson,
                NavigationCases.UserInfo.orderID.rawValue: orderID
            ]
        }
    }
    
}

//MARK: - Extension

//MARK: For client
extension DatabaseManager.ClientInfo: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[NavigationCases.Review.name.rawValue] as? String,
            let phone = dictionary[NavigationCases.ForClientData.phone.rawValue] as? String,
            let orderCount = dictionary[NavigationCases.ForClientData.orderCount.rawValue] as? Int,
            let deviceID = dictionary[NavigationCases.ForClientData.deviceID.rawValue] as? String,
            let lastAdress = dictionary[NavigationCases.ForClientData.lastAdress.rawValue] as? String else {return nil}
        self.init(name: name, phone: phone, orderCount: orderCount, deviceID: deviceID, lastAdress: lastAdress)
    }
}
 
//MARK: For review
extension DatabaseManager.Review: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[NavigationCases.Review.name.rawValue] as? String,
            let content = dictionary[NavigationCases.Review.content.rawValue] as? String,
            let uid = dictionary[NavigationCases.Review.uid.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.Review.timeStamp.rawValue] as? Timestamp)?.dateValue() else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}

//MARK: For product info
extension DatabaseManager.ProductInfo: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let productName = dictionary[NavigationCases.Product.productName.rawValue] as? String,
            let productPrice = dictionary[NavigationCases.Product.productPrice.rawValue] as? Int,
            let productDescription = dictionary[NavigationCases.Product.productDescription.rawValue] as? String,
            let productCategory = dictionary[NavigationCases.Product.productCategory.rawValue] as? String,
            let productSubCategory  = dictionary[NavigationCases.Product.productSubCategory.rawValue] as? String,
            let stock = dictionary[NavigationCases.Product.stock.rawValue] as? Bool,
            let productID = dictionary[NavigationCases.Product.productID.rawValue] as? String,
            let searchArray = dictionary[NavigationCases.Product.searchArray.rawValue] as? [String],
            let voteCount = dictionary[NavigationCases.Product.voteCount.rawValue] as? Int,
            let voteAmount = dictionary[NavigationCases.Product.voteAmount.rawValue] as? Int else {return nil}
        self.init(productName: productName, productPrice: productPrice, productDescription: productDescription, productCategory: productCategory, productSubCategory: productSubCategory, stock: stock, productID: productID, searchArray: searchArray, voteCount: voteCount, voteAmount: voteAmount)
    }
}

//MARK: For product filtering
extension DatabaseManager.ProductFilter: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let flower = dictionary[NavigationCases.ProductCategories.flower.rawValue] as? [String],
        let bouquet = dictionary[NavigationCases.ProductCategories.bouquet.rawValue] as? [String],
        let gift = dictionary[NavigationCases.ProductCategories.gift.rawValue] as? [String] else {return nil}
        self.init(flower: flower, bouquet: bouquet, gift: gift)
    }
}

//MARK: For order
extension DatabaseManager.Order: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let totalPrice = dictionary[NavigationCases.UserInfo.totalPrice.rawValue] as? Int64,
            let userName = dictionary[NavigationCases.UserInfo.name.rawValue] as? String,
            let userAdress = dictionary[NavigationCases.UserInfo.adress.rawValue] as? String,
            let userCellphone = dictionary[NavigationCases.UserInfo.cellphone.rawValue] as? String,
            let feedbackOption = dictionary[NavigationCases.UserInfo.feedbackOption.rawValue] as? String,
            let userMark = dictionary[NavigationCases.UserInfo.mark.rawValue] as? String,
            let timeStamp = (dictionary[NavigationCases.UserInfo.timeStamp.rawValue] as? Timestamp)?.dateValue(),
            let currentDeviceID = dictionary[NavigationCases.UserInfo.currentDeviceID.rawValue] as? String,
            let deliveryPerson = dictionary[NavigationCases.UserInfo.deliveryPerson.rawValue] as? String,
        let orderID = dictionary[NavigationCases.UserInfo.orderID.rawValue] as? String else {return nil}
        self.init(totalPrice: totalPrice, name: userName, adress: userAdress, cellphone: userCellphone, feedbackOption: feedbackOption, mark: userMark, timeStamp: timeStamp, currentDeviceID: currentDeviceID, deliveryPerson: deliveryPerson, orderID: orderID)
    }
}


/*
 let gifts = ["Все", "Вазы", "Гелиевые шарики", "Сладкое", "Корзины", "Фруктовые корзины", "Козины из сладостей", "Мягкие игрушки", "Открытки", "Торты"]
 let flowers = ["Все", "Амараллис", "Ананас", "Антуриум", "Альстромерия", "Бамбук", "Брассика", "Бруния", "Ванда", "Гвоздика", "Гербера", "Гиацит", "Гипсофила", "Гортензия", "Ирис", "Калла", "Леукодендрон", "Лилия", "Орхидея Цимбидиум", "Пион", "Подсолнух", "Протея", "Ранункулюс", "Роза", "Роза Эквадор", "Роза Голландия", "Роза Кения", "Роза спрей", "Ромашка", "Хиперикум", "Тюльпан", "Фрезия", "Хелеборус", "Хлопок", "Хризантема", "Эрингиум", "Эустома"]
 let bouquet = ["Все", "Авторские", "Из роз", "Из 101 розы", "Классические", "Недорогие букеты", "Свадебные", "Фруктовые", "Эксклюзивные", "В форме сердца", "В боксах", "Со сладостями"]
 
 */
