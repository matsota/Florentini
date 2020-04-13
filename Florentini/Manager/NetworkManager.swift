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

class NetworkManager {
    
    //MARK: - Системные переменные
    static let shared = NetworkManager()
    let db = Firestore.firestore()
    
    ///
    //MARK: - Crud
    ///
    
    //MARK: - Send review
    func sendReview(name: String, content: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newReview = DatabaseManager.Review(name: name, content: content, uid: "\(currentDeviceID)", timeStamp: Date())
        
        db.collection(NavigationCases.Review.review.rawValue).addDocument(data: newReview.dictionary) {
            error in
            if let error = error {
                failure(error)
            }else{
                success()
            }
        }
    }
    
    //MARK: - Order Confirm
    func orderConfirm(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, productDescription: [String : Any], success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: "\(currentDeviceID)", deliveryPerson: "none")
        
        db.collection(NavigationCases.UsersInfo.order.rawValue).document("\(currentDeviceID)").setData(newOrder.dictionary) {
            error in
            if let error = error {
                failure(error)
            }else{
                self.db.collection(NavigationCases.UsersInfo.order.rawValue).document("\(currentDeviceID)").collection("\(currentDeviceID)").document().setData(productDescription)
                success()
            }
        }
    }
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: - Download all products
    func downloadProducts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.Product.imageCollection.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only bouquets
    func downloadBouquets(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.Product.imageCollection.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.bouquet.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only apieces
    func downloadApieces(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.Product.imageCollection.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.apiece.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only gifts
    func downloadGifts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.Product.imageCollection.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.gift.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only stock
    func downloadStocks(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.Product.imageCollection.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: true).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }

}

//MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
