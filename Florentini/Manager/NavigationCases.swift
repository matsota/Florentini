//
//  NavigationCases.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class NavigationCases {
    
    //MARK: -
    
    //MARK: - Для ViewController'ов
    enum IDVC: String, CaseIterable {
        
        // - for clients
        case MenuVC
        
        case UsersCartVC
        case CatalogVC
        case FeedbackVC
        case FAQVC
        
        case UserCatalogTVCell
        case UsersCartTVCell
        case UserHomeTVCell
        
        // - for workers
        case EmployerMenuVC
        
        case LoginWorkSpaceVC
        case EmployerOrdersVC
        case EmployerCatalogVC
        case EmployerProfileVC
        case EmployerFAQVC
        case EmployerChatVC
        
        case NewProductSetVC
        
        case EmployerMessagesTVCell
        case EmployerCatalogTVCell
        case EmployerOrdersTVCell
        case EmployerOrdersDetailTVCell
        
    }
    
    //MARK: -
    
    //MARK: - Для сотрудников
    enum WorkerInfoCases: String, CaseIterable {
        
        case name
        case position
        case admin
        case `operator`
        case delivery
        
    }
    
    //MARK: - Про Notifications
    enum Notification: String, CaseIterable {
        
        case newMessage
        
    }
    
    //MARK: - Про Сообщения
    enum MessagesCases: String, CaseIterable {
        
        case name
        case content
        case uid
        case timeStamp
        case workers
        case workersMessages
        case review
        
    }
    
    //MARK: - Про Товар
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
    
    //MARK: - Про Категории
    enum CategorySwitch: String, CaseIterable{
        
        case none = "Без Категории"
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
        
    }
    
    //MARK: - Про Архив
    enum ArchiveCases: String, CaseIterable{
        
        case archivedOrders
        case archivedOrderAdditions
        case deletedOrders
        
    }
    
    //MARK: - Для пользоватей
    
    enum TranstionCases: String, CaseIterable {
        
        case homeScreen = "Главная"
        case catalogScreen = "Каталог"
        case feedbackScreen = "О нас"
        case faqScreen = "FAQ"
        case website = "Website"
        
    }
    
    //MARK: - Про заказ
    enum UsersInfoCases: String, CaseIterable {
        
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
        case orderDescription
        
        case PreOrderEntity
        case OrderDetailPathEntity
        
    }
    
    //MARK: - Про обратную связь
    enum FeedbackTypesCases: String, CaseIterable {
        
        case cellphone = "По телефону"
        case viber = "Viber"
        case telegram = "Telegram"
        
    }
    
    //MARK: - Про количество
    enum MaxQuantityByCategoriesCases: Int {
        
        case towHundred = 200
        //        case hundredAndHalf = 150
        case hundred = 100
        //        case halfHundred = 50
        case five = 5
        case three = 3
        
    }
    
    //MARK: - Про Категории
    enum ProductCategoriesCases: String, CaseIterable {
        
        case apiece = "Поштучно"
        case gift = "Подарки"
        case bouquet = "Букеты"
        case stock = "Акции"
        
    }
    
}


