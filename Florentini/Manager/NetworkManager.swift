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
    
    //MARK: - О продуктах:
    //MARK: - Метод выгрузки Информации о продукте продукта из Firebase
    func downLoadProductInfo(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downLoadBouquetOnly(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).whereField(DatabaseManager.ProductCases.productCategory.rawValue, isEqualTo: DatabaseManager.ProductCategoriesCases.bouquet.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downLoadApieceOnly(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).whereField(DatabaseManager.ProductCases.productCategory.rawValue, isEqualTo: DatabaseManager.ProductCategoriesCases.apiece.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downLoadStockOnly(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).whereField(DatabaseManager.ProductCases.productCategory.rawValue, isEqualTo: DatabaseManager.ProductCategoriesCases.stock.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    func downLoadGiftOnly(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).whereField(DatabaseManager.ProductCases.productCategory.rawValue, isEqualTo: DatabaseManager.ProductCategoriesCases.gift.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
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
        
        let uploadRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(name)")
        
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
    
    //MARK: - Метод внесения информации  о товаре в Firebase
    func setProductDescription(name: String, price: Int, category: String, description: String, documentNamedID: String) {
        
        let imageTemplate = [
            DatabaseManager.ProductCases.productName.rawValue: name,
            DatabaseManager.ProductCases.productPrice.rawValue: price,
            DatabaseManager.ProductCases.productCategory.rawValue: category,
            DatabaseManager.ProductCases.productDescription.rawValue: description
            ] as [String: Any]
        
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).document(documentNamedID).setData(imageTemplate, merge: true)
    }
    
    //MARK: - Метод удаления продукта из базы данных
    func deleteProduct(name: String){
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).document(name).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        let imageRef = Storage.storage().reference().child("\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(name)")
        imageRef.delete { error in
            if let error = error {
                print("error ocured: \(error.localizedDescription)")
            } else {
                print ("File deleted successfully")
            }
        }
    }
    
    //MARK: - Редактирование существующих продуктов в Worker-Catalog
    func editProductPrice(name: String, newPrice: Int, category: String, description: String) {
        let updatePrice = [
            DatabaseManager.ProductCases.productName.rawValue: name,
            DatabaseManager.ProductCases.productPrice.rawValue: newPrice,
            DatabaseManager.ProductCases.productCategory.rawValue: category,
            DatabaseManager.ProductCases.productDescription.rawValue: description
            ] as [String: Any]
        
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).document(name).setData(updatePrice)
    }
    
    
    //MARK: - О Пользователях:
    //MARK: - Отправка отзыва
    func sendReview(name: String, content: String) {
        let newReview = DatabaseManager.ChatMessages(name: name, content: content, uid: AuthenticationManager.shared.currentUser!.uid, timeStamp: Date())
        
        db.collection(DatabaseManager.MessagesCases.workersMessages.rawValue).addDocument(data: newReview.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                print("Review Sent")
            }
        }
    }
    
    func sendOrder(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, productDescription: [String : Any]) {
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark)
        guard let currentIDDevice = CoreDataManager.shared.device.identifierForVendor else {return}

        db.collection(DatabaseManager.ProductCases.order.rawValue).document("\(currentIDDevice)").setData(newOrder.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                print("Order Completed")
                self.db.collection(DatabaseManager.ProductCases.order.rawValue).document("\(currentIDDevice)").collection(DatabaseManager.ProductCases.orderDescription.rawValue).document().setData(productDescription)
            }
        }
        
    }
    
    //MARK: - О Сотрудниках:
    //MARK: - Workers Dataload
    func workersInfoLoad (success: @escaping([DatabaseManager.WorkerInfo]) -> Void, failure: @escaping(Error) -> Void) {
        let uid = AuthenticationManager.shared.currentUser?.uid
        if uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection(DatabaseManager.MessagesCases.workers.rawValue).document(uid!).getDocument { (documentSnapshot, _) in
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
            db.collection(DatabaseManager.MessagesCases.workersMessages.rawValue).getDocuments(completion: {
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
        
        ref = db.collection(DatabaseManager.MessagesCases.workersMessages.rawValue).addDocument(data: newMessage.dictionary) {
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
        db.collection(DatabaseManager.MessagesCases.workersMessages.rawValue).whereField(DatabaseManager.MessagesCases.timeStamp.rawValue, isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    guard let newMessage = DatabaseManager.ChatMessages(dictionary: diff.document.data()) else {return}
                    success(newMessage)
                }
            }
        }
    }
    
}


//MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
