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
    
    //MARK: - Send review
    func sendReview(name: String, content: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newReview = DatabaseManager.Review(name: name, content: content, uid: "\(currentDeviceID)", timeStamp: Date())
        
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
    func orderConfirm(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, productDescription: [String : Any], success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: "\(currentDeviceID)", deliveryPerson: "none")
        
        var ref: DocumentReference? = nil
        ref = db.collection(NavigationCases.FirstCollectionRow.order.rawValue).document()
        
        ref!.setData(newOrder.dictionary) {
            error in
            if let error = error {
                failure(error)
            }else{
                self.db.collection(NavigationCases.FirstCollectionRow.order.rawValue).document(ref!.documentID).collection("\(currentDeviceID)").document().setData(productDescription)
                success()
            }
        }
    }
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: - Download all products
    func downloadProductsInfo(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only bouquets
    func downloadBouquetsInfo(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.bouquet.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only apieces
    func downloadApieces(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.apiece.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Only gifts
    func downloadGifts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.FirstCollectionRow.productInfo.rawValue).whereField(NavigationCases.Product.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategories.gift.rawValue).whereField(NavigationCases.Product.stock.rawValue, isEqualTo: false).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
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
    
    func updateClientData(data: [String : Any], success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        
        guard let newData = DatabaseManager.ClientInfo(dictionary: data),
            let currentDeviceID = CoreDataManager.shared.device else {return}
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
                            if newData.lastAdress != oldData.lastAdress || newData.name != oldData.name || newData.phone != oldData.phone {
                                ref?.collection(NavigationCases.ForClientData.adress.rawValue).addDocument(data:[NavigationCases.ForClientData.adress.rawValue: oldData.lastAdress, NavigationCases.ForClientData.name.rawValue: oldData.name, NavigationCases.ForClientData.phone.rawValue: oldData.phone]) { _ in
                                ref?.updateData([NavigationCases.ForClientData.lastAdress.rawValue : newData.lastAdress])
                                    ref?.updateData([NavigationCases.ForClientData.name.rawValue : newData.name])
                                    ref?.updateData([NavigationCases.ForClientData.phone.rawValue: newData.phone])
                                    success()
                                }
                            }
                        }
                        
                    })
                }else{
                    ref?.setData(newData.dictionary) { (error) in
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
