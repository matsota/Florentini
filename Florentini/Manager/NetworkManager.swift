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
    
    //MARK: - Общее:
    
    //MARK: - Метод выгрузки Информации о продукте продукта из Firebase
    func downloadProducts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downloadBouquets(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.bouquet.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downloadApieces(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.apiece.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downloadGifts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.gift.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downloadStocks(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.stock.rawValue, isEqualTo: true).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Метод Архивирования заказов
    func archiveOrder(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, orderKey: String){
        
        let data =  DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, deviceID: orderKey)
        
        let path = self.db.collection(NavigationCases.ArchiveCases.archive.rawValue).document(orderKey)
        path.collection(NavigationCases.ArchiveCases.orders.rawValue).addDocument(data: data.dictionary)
        self.archiveOrderAddition(orderKey: orderKey)
        
    }
    
    //MARK: Архивирования описания заказов
    func archiveOrderAddition(orderKey: String) {
        var addition = [DatabaseManager.OrderAddition](),
        jsonArray: [[String: Any]] = []
        
        let docRef = db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(orderKey)
        docRef.collection(orderKey).getDocuments(completion: {
            (querySnapshot, _) in
            addition = querySnapshot!.documents.compactMap{DatabaseManager.OrderAddition(dictionary: $0.data())}
            for i in addition {
                jsonArray.append(i.dictionary)
            }
            
            for _ in jsonArray {
                let path =  self.db.collection(NavigationCases.ArchiveCases.archive.rawValue).document(orderKey)
                path.collection(NavigationCases.ArchiveCases.orderedProducts.rawValue).addDocument(data: jsonArray.remove(at: 0))
            }
        })
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(orderKey).delete()
        deleteAdditions(collection: docRef.collection(orderKey))
    }
    
    //MARK: Удаление Всего Заказа
    func deleteAdditions(collection: CollectionReference, batchSize: Int = 100) {
        
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            let docset = docset,
            batch = collection.firestore.batch()
            
            docset?.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { _ in
                self.deleteAdditions(collection: collection, batchSize: batchSize)
            }
        }
    }
    
    
    
    //MARK: - Для Админа:
    
    //MARK: - Метод Загрузки изображения по Ссылке в приложение
    func downLoadImageByURL(url: String, success: @escaping(UIImage) -> Void) {
        if let url = URL(string: url){
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {return}
                success(image)
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Метод загрузки Фотографии продукта в Firebase
    func uploadProduct(image: UIImageView, name: String, progressIndicator: UIProgressView, complition: @escaping() -> Void) {
        guard AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid else {return}
        
        progressIndicator.isHidden = false
        
        let uploadRef = Storage.storage().reference(withPath: "\(NavigationCases.ProductCases.imageCollection.rawValue)/\(name)")
        
        guard let imageData = image.image?.jpegData(compressionQuality: 0.75) else {return}
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpg"
        
        let taskRef = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no! \(error.localizedDescription)")
                return
            }
            print("Done with metadata: \(String(describing: downloadMetadata))")
            complition()
        }
        taskRef.observe(.progress){ (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
            progressIndicator.progress = Float(pctThere)
        }
        taskRef.observe(.success) {_ in
            progressIndicator.isHidden = true
        }
    }
    
    //MARK: - Метод внесения информации о товаре в Firebase
    func setProductDescription(name: String, price: Int, description: String, category: String, stock: Bool) {
        
        let imageTemplate = DatabaseManager.ProductInfo(productName: name, productPrice: price, productDescription: description, productCategory: category, stock: stock)
        
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name).setData(imageTemplate.dictionary)
    }
    
    //MARK: - Редактирование цены существующего продукта в Worker-Catalog
    func editProductPrice(name: String, newPrice: Int, category: String, description: String, stock: Bool) {
        let updatePrice = DatabaseManager.ProductInfo(productName: name, productPrice: newPrice, productDescription: description, productCategory: category, stock: stock)
        
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name).setData(updatePrice.dictionary)
    }
    
    func editStockCondition(name: String, price: Int, category: String, description: String, stock: Bool) {
        let updatePrice = DatabaseManager.ProductInfo(productName: name, productPrice: price, productDescription: description, productCategory: category, stock: stock)
        
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name).setData(updatePrice.dictionary)
    }
    
    //MARK: - Метод удаления продукта из базы данных
    func deleteProduct(name: String){
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        let imageRef = Storage.storage().reference().child("\(NavigationCases.ProductCases.imageCollection.rawValue)/\(name)")
        imageRef.delete { error in
            if let error = error {
                print("error ocured: \(error.localizedDescription)")
            } else {
                print ("File deleted successfully")
            }
        }
    }
    
    //MARK: - Для пользователей:
    
    //MARK: - Отправка отзыва
    func sendReview(name: String, content: String) {
        guard let uid = CoreDataManager.shared.device.identifierForVendor else {return}
        let newReview = DatabaseManager.ChatMessages(name: name, content: content, uid: "\(uid)", timeStamp: Date())
        
        db.collection(NavigationCases.MessagesCases.review.rawValue).addDocument(data: newReview.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                print("Review Sent")
            }
        }
    }
    
    //MARK: - Подтверждение заказа
    func sendOrder(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, productDescription: [String : Any], success: @escaping() -> Void) {
        guard let currentIDDevice = CoreDataManager.shared.device.identifierForVendor else {return}
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, deviceID: "\(currentIDDevice)")
        
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).document("\(currentIDDevice)").setData(newOrder.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                self.db.collection(NavigationCases.UsersInfoCases.order.rawValue).document("\(currentIDDevice)").collection("\(currentIDDevice)").document().setData(productDescription)
                success()
            }
        }
    }
    
    //MARK: - Для всех сотрудников:
    
    //MARK: - Workers Dataload
    func workersInfoLoad (success: @escaping([DatabaseManager.WorkerInfo]) -> Void, failure: @escaping(Error) -> Void) {
        let uid = AuthenticationManager.shared.currentUser?.uid
        if uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection(NavigationCases.MessagesCases.workers.rawValue).document(uid!).getDocument { (documentSnapshot, _) in
                guard let workerInfo = DatabaseManager.WorkerInfo(dictionary: documentSnapshot!.data()!) else {return}
                success([workerInfo])
            }
        }
    }
    
    //MARK: - Получение всех сообщений  для чата сотрудников
    func workersChatLoad(success: @escaping([DatabaseManager.ChatMessages]) -> Void, failure: @escaping(Error) -> Void) {
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection(NavigationCases.MessagesCases.workersMessages.rawValue).getDocuments(completion: {
                (querySnapshot, _) in
                let messages = querySnapshot!.documents.compactMap{DatabaseManager.ChatMessages(dictionary: $0.data())}
                success(messages)
            })
        }
    }
    
    //MARK: - Отправка сообщения в Чате сотрудников
    func newChatMessage(name: String, content: String) {
        let newMessage = DatabaseManager.ChatMessages(name: name, content: content, uid: AuthenticationManager.shared.currentUser!.uid, timeStamp: Date())
        var ref: DocumentReference? = nil
        
        ref = db.collection(NavigationCases.MessagesCases.workersMessages.rawValue).addDocument(data: newMessage.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                print("It's ok. Doc ID: \(ref!.documentID)")
            }
        }
    }
    
    //MARK: - Обновление содержимого Чата
    func chatUpdate(success: @escaping(DatabaseManager.ChatMessages) -> Void) {
        db.collection(NavigationCases.MessagesCases.workersMessages.rawValue).whereField(NavigationCases.MessagesCases.timeStamp.rawValue, isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    guard let newMessage = DatabaseManager.ChatMessages(dictionary: diff.document.data()) else {return}
                    success(newMessage)
                }
            }
        }
    }
    
    //MARK: - Метод выгрузки Информации о заказе из Firebase
    func downloadMainOrderInfo(success: @escaping([DatabaseManager.Order]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let orders = querySnapshot!.documents.compactMap{DatabaseManager.Order(dictionary: $0.data())}
            success(orders)
        })
    }
    
    //MARK: - Обновление содержимого Чата
    func updateOrders(success: @escaping(DatabaseManager.Order) -> Void) {
        
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).whereField(NavigationCases.MessagesCases.timeStamp.rawValue, isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    guard let newOrder = DatabaseManager.Order(dictionary: diff.document.data()) else {return}
                    success(newOrder)
                }
            }
        }
    }
    
    func downloadOrderdsAddition(success: @escaping([DatabaseManager.OrderAddition]) -> Void, failure: @escaping(Error) -> Void) {
        
        var key = String()
        CoreDataManager.shared.fetchOrderPath { path -> (Void) in
            key = path.map({$0.path}).last!!
        }
        
        let docRef = db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(key)
        
        docRef.collection(key).getDocuments(completion: {
            (querySnapshot, _) in
            let addition = querySnapshot!.documents.compactMap{DatabaseManager.OrderAddition(dictionary: $0.data())}
            success(addition)
        })
    }
    
}


//MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
