//
//  NetworkManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseUI
import FirebaseDatabase

class NetworkManager {
    
    //MARK: - Системные переменные
    static let shared = NetworkManager()
    let db = Firestore.firestore()
    
    ///
    //MARK: - Crud
    ///
    
    func createRefs() {
        let gifts = ["Все", "Вазы", "Гелиевые шарики", "Сладкое", "Корзины", "Фруктовые корзины", "Козины из сладостей", "Мягкие игрушки", "Открытки", "Торты"]
        let flowers = ["Все", "Амараллис", "Ананас", "Антуриум", "Альстромерия", "Бамбук", "Брассика", "Бруния", "Ванда", "Гвоздика", "Гербера", "Гиацит", "Гипсофила", "Гортензия", "Ирис", "Калла", "Леукодендрон", "Лилия", "Орхидея Цимбидиум", "Пион", "Подсолнух", "Протея", "Ранункулюс", "Роза", "Роза Эквадор", "Роза Голландия", "Роза Кения", "Роза спрей", "Ромашка", "Хиперикум", "Тюльпан", "Фрезия", "Хелеборус", "Хлопок", "Хризантема", "Эрингиум", "Эустома"]
        let bouquet = ["Все", "Авторские", "Из роз", "Из 101 розы", "Классические", "Недорогие букеты", "Свадебные", "Фруктовые", "Эксклюзивные", "В форме сердца", "В боксах", "Со сладостями"]
        
        
        let data: [String:Any] = [NavigationCases.ProductCategories.bouquet.rawValue: bouquet,
                                  NavigationCases.ProductCategories.flower.rawValue: flowers,
                                  NavigationCases.ProductCategories.gift.rawValue: gifts
        ]
        let data2: [String:Any] = [NavigationCases.ProductCategories.bouquet.rawValue: NavigationCases.ProductCategories.bouquet.rawValue,
                                  NavigationCases.ProductCategories.flower.rawValue: NavigationCases.ProductCategories.flower.rawValue,
                                  NavigationCases.ProductCategories.gift.rawValue: NavigationCases.ProductCategories.gift.rawValue
        ]
        db.collection(NavigationCases.FirstCollectionRow.searchProduct.rawValue).document(NavigationCases.SearchProduct.productSubCategory.rawValue).setData(data)
        db.collection(NavigationCases.FirstCollectionRow.searchProduct.rawValue).document(NavigationCases.SearchProduct.productCategory.rawValue).setData(data2)
    }
    
    //MARK: - Send review
    func sendReview(newReview: DatabaseManager.Review, content: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.review.rawValue).addDocument(data: newReview.dictionary) {
            error in
            if let error = error {
                failure(error)
            }else{
                success()
            }
        }
    }
    
    //MARK: - Order Confirm
    func orderConfirm(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, success: @escaping(DocumentReference) -> Void, failure: @escaping(Error) -> Void) {
        
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        var ref: DocumentReference? = nil
        ref = db.collection(NavigationCases.FirstCollectionRow.order.rawValue).document()
        
        
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: "\(currentDeviceID)", deliveryPerson: "none", orderID: ref!.documentID)
        
        ref!.setData(newOrder.dictionary) { error in
            if let error = error {
                failure(error)
            }else{
                guard let ref = ref else {return}
                success(ref)
            }
        }
    }
    
    func orderDescriptionConfirm(path: String, orderDescription: [String : Any]) {
        self.db.collection(NavigationCases.FirstCollectionRow.order.rawValue).document(path).collection(NavigationCases.Product.orderDescription.rawValue).document().setData(orderDescription)
    }
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: - Download Strings for filtering Table View
    func downloadFilteringDict(success: @escaping(DatabaseManager.ProductFilter) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.searchProduct.rawValue).document(NavigationCases.SearchProduct.productSubCategory.rawValue).getDocument { (documentSnapshot, error) in
            if let error = error {
                failure(error)
            }else{
                guard let data = DatabaseManager.ProductFilter(dictionary: documentSnapshot!.data()!) else {return}
                success(data)
            }
        }
    }
    
    //MARK: - Download all products
    func downloadProductsInfo(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downloadByCategory(category: String, success: @escaping(_ productInfo: [DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: category).getDocuments(completion: {
            (querySnapshot, error) in
            if let error = error {
                failure(error)
            }else{
                let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
                success(productInfo)
            }
        })
    }
    
    func downloadBySubCategory(category: String, subCategory: String, success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.SearchProduct.productSubCategory.rawValue, isEqualTo: category).whereField(NavigationCases.Product.productSubCategory.rawValue, isEqualTo: subCategory).getDocuments(completion: {
            (querySnapshot, error) in
            if let error = error {
                failure(error)
            }else{
                let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
                success(productInfo)
            }
        })
    }
    
    //MARK: - Only stock
    func downloadStocks(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: true).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    ///
    //MARK: - crUd
    ///
    
    //MARK: - Update Client
    func updateClientData(clientData: DatabaseManager.ClientInfo, success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        var ref: DocumentReference? = nil
        ref = db.collection(NavigationCases.FirstCollectionRow.clientData.rawValue).document("\(currentDeviceID)")
        
        ref?.getDocument(completion: { (documentSnapshot, error) in
            if let error = error {
                print(error)
            }else{
                if documentSnapshot?.exists == true {
                    let oldData = DatabaseManager.ClientInfo(dictionary: documentSnapshot!.data()!)
                    ref?.updateData([NavigationCases.ForClientData.orderCount.rawValue: oldData!.orderCount + 1], completion: { _ in
                        if let error = error {
                            print(error.localizedDescription)
                            failure(error)
                        }else{
                            guard let oldData = DatabaseManager.ClientInfo(dictionary: documentSnapshot!.data()!) else {return}
                            if clientData.lastAdress != oldData.lastAdress || clientData.name != oldData.name || clientData.phone != oldData.phone {
                                ref?.collection(NavigationCases.ForClientData.adress.rawValue).addDocument(data:[NavigationCases.ForClientData.adress.rawValue: oldData.lastAdress, NavigationCases.ForClientData.name.rawValue: oldData.name, NavigationCases.ForClientData.phone.rawValue: oldData.phone]) { _ in
                                    ref?.updateData([NavigationCases.ForClientData.lastAdress.rawValue : clientData.lastAdress])
                                    ref?.updateData([NavigationCases.ForClientData.name.rawValue : clientData.name])
                                    ref?.updateData([NavigationCases.ForClientData.phone.rawValue: clientData.phone])
                                    success()
                                }
                            }
                        }
                        
                    })
                }else{
                    ref?.setData(clientData.dictionary) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            failure(error)
                        }else{
                            success()
                        }
                    }
                }
            }
        })
    }
    
    
}

//MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
