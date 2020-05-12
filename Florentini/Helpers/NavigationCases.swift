//
//  NavigationCases.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class NavigationCases {
    
    //MARK: - Для ViewController'ов
    enum IDVC: String, CaseIterable {
        
        case UsersCartVC
        case CatalogVC
        case FeedbackVC
        case FAQVC
        
        case CatalogTVCell
        case CartTVCell
        case HomeTVCell
        
        
    }
    
    //MARK: - for CoreData
    enum CoreData: String, CaseIterable {
        
        case PreOrderEntity
        
    }
    
    //MARK: - First Collection path in Firebase
    enum FirstCollectionRow: String, CaseIterable {
        
        case productInfo
        case imageCollection
        case order
        case review
        
    }
    
    //MARK: - Про Сообщения
    enum Review: String, CaseIterable {
        
        case name
        case content
        case uid
        case timeStamp
        
    }
    
    //MARK: - About Product
    enum Product: String, CaseIterable {
        
        case productName
        case productPrice
        case productQuantity
        case productCategory
        case productDescription
        case productImageURL
        case imageCollection
        case stock
        
    }
    
    //MARK: - Transtion Cases
    
    enum ScreenTranstion: String, CaseIterable {
        
        case homeScreen = "Главная"
        case catalogScreen = "Каталог"
        case feedbackScreen = "О нас"
        case faqScreen = "FAQ"
        case website = "Website"
        
    }
    
    //MARK: - About Order attributes
    enum UsersInfo: String, CaseIterable {
        
        case totalPrice
        case name
        case adress
        case cellphone
        case feedbackOption
        case mark
        case timeStamp
        case currentDeviceID
        case deliveryPerson
        
        case cart
        case order
        
    }
    
    //MARK: - About feedback options
    enum Feedback: String, CaseIterable {
        
        case cellphone = "По телефону"
        case viber = "Viber"
        case telegram = "Telegram"
        
    }
    
    //MARK: - For slider value
    enum MaxSliderValueByCategories: Int {
        
        case towHundred = 200
        //        case hundredAndHalf = 150
        case hundred = 100
        //        case halfHundred = 50
        case five = 5
        //        case three = 3
        
    }
    
    //MARK: - Categories
    enum ProductCategories: String, CaseIterable {
        
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
        case stock = "Акции"
        
    }
    
    
    //MARK: Clients
    
    enum ForClientData: String, CaseIterable {
        case name
        case phone
        case orderCount
        case deviceID
        case lastAdress
        case adressesDict
        case productDict
    }
    
}


