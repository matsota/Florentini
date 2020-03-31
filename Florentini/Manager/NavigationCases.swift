//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class NavigationCases {
    
    //MARK: - Для ViewController'ов
    enum IDVC: String, CaseIterable {
        
        //for clients
        case MenuVC
        
        case UsersCartVC
        case CatalogVC
        case FeedbackVC
        case FAQVC
        
        case UserCatalogTVCell
        case UsersCartTVCell
        case UserHomeTVCell
        
        //for workers
        case WorkMenuVC
        
        case LoginWorkSpaceVC
        case MainWorkSpaceVC
        case WorkerCatalogVC
        case WorkerProfileVC
        case WorkersFAQVC
        case WorkersChatVC
        case NewProductSetVC
    
        case WorkerMessagesTVCell
        case WorkerCatalogTVCell
        case WorkerOrdersTVCell
        case WorkerOrdersDetailTVCell
    }
    
    //MARK: Для сотрудников
    enum WorkerInfoCases: String, CaseIterable {
        case name
        case position
        case admin
        case `operator`
        case delivery
    }
    
    //MARK: Для пользоватей
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
    
    //MARK: Для Сообщений
    enum MessagesCases: String, CaseIterable {
        case name
        case content
        case uid
        case timeStamp
        case workers
        case workersMessages
    }
    
    //MARK: Для Товара
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
    
    //MARK: Категории товара
    enum ProductCategoriesCases: String, CaseIterable {
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
    
    //MARK: Для обратную связь
    enum FeedbackTypesCases: String, CaseIterable {
        case cellphone = "По телефону"
        case viber = "Viber"
        case telegram = "Telegram"
    }
    
    enum CategorySwitch: String, CaseIterable{
        case none = "Без Категории"
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
    }

}


