//
//  NetworkManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI

class NetworkManager {
    
    //MARK: - Системные переменные
    static let shared = NetworkManager()
    let db = Firestore.firestore()
    
    //MARK: - Workers Dataload
    func workersInfoLoad (success: @escaping([DatabaseManager.WorkerInfo]) -> Void, failure: @escaping(Error) -> Void) {
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
        db.collection(DatabaseManager.ChatMessagesCases.workers.rawValue).document(AuthenticationManager.shared.currentUser!.uid).getDocument { (documentSnapshot, _) in
            guard let workerInfo = DatabaseManager.WorkerInfo(dictionary: documentSnapshot!.data()!) else {return}
            success([workerInfo])
            }
        }
    }
    
    //MARK: - Получение всех сообщений  для чата сотрудников
    func workersMessagesLoad(success: @escaping([DatabaseManager.ChatMessages]) -> Void, failure: @escaping(Error) -> Void) {
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection(DatabaseManager.ChatMessagesCases.workersMessages.rawValue).getDocuments(completion: {
                (querySnapshot, _) in
                let messages = querySnapshot!.documents.compactMap{DatabaseManager.ChatMessages(dictionary: $0.data())}
                success(messages)
            })
        }
    }
    
    
    //MARK: - Отправка сообщения в Чате сотрудников
    func sendMessage(name: String, content: String) {
        let newMessage = DatabaseManager.ChatMessages(name: name, content: content, uid: AuthenticationManager.shared.currentUser!.uid, timeStamp: Date())
        var ref: DocumentReference? = nil
        
        ref = db.collection(DatabaseManager.ChatMessagesCases.workersMessages.rawValue).addDocument(data: newMessage.dictionary) {
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
        db.collection(DatabaseManager.ChatMessagesCases.workersMessages.rawValue).whereField(DatabaseManager.ChatMessagesCases.timeStamp.rawValue, isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    guard let newMessage = DatabaseManager.ChatMessages(dictionary: diff.document.data()) else {return}
                    success(newMessage)
                }
            }
        }
    }
    
    
    //MARK: - О продуктах
    //MARK: - Метод выгрузки Фотографии продукта из Firebase
    func downLoadProductInfo(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).getDocuments(completion: {
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
    func uploadPhoto(image: UIImageView, name: String, progressIndicator: UIProgressView, complition: @escaping() -> Void) {
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
    func imageData(name: String, price: Int, category: String, description: String, documentNamedID: String) {
        
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
    
    
    //MARK: - Метод Создания Предзаказа
    func makePreOrder(name: String, price: Int) {
        let preOrderInfo = DatabaseManager.PreOrder(productName: name, productPrice: price)
    
        guard AuthenticationManager.shared.currentUser?.uid != nil else {return}
        db.collection(DatabaseManager.ProductCases.preOrder.rawValue).document(AuthenticationManager.shared.currentUser!.uid).collection(DatabaseManager.ProductCases.preOrder.rawValue).document(name).setData(preOrderInfo.dictionary)
    }
    
    //MARK: - Метод Получения информации о предзаказе для Пользователя в Корзину
    func getPreOrder(success: @escaping([DatabaseManager.PreOrder]) -> Void, failure: @escaping(Error) -> Void) {
        guard AuthenticationManager.shared.currentUser?.uid != nil else {return}
        db.collection(DatabaseManager.ProductCases.preOrder.rawValue).document(AuthenticationManager.shared.currentUser!.uid).collection(DatabaseManager.ProductCases.preOrder.rawValue).getDocuments { (querySnapshot, error) in
            if let error = error {
                failure (error)
            }
            let preOrder = querySnapshot!.documents.compactMap{DatabaseManager.PreOrder(dictionary: $0.data())}
            success(preOrder)
        }
    }
    //MARK: - Метод удаления продукта из корзины
    func deletePreOrderProduct(name: String){
        db.collection(DatabaseManager.ProductCases.preOrder.rawValue).document(AuthenticationManager.shared.currentUser!.uid).collection(DatabaseManager.ProductCases.preOrder.rawValue).document(name).delete()
    }
    
    func updatePreOrder(name: String, success: @escaping(DatabaseManager.PreOrder) -> Void) {
        guard let user = AuthenticationManager.shared.currentUser?.uid else {return}
        db.collection(DatabaseManager.ProductCases.preOrder.rawValue).document(user).collection(DatabaseManager.ProductCases.preOrder.rawValue).whereField(DatabaseManager.ProductCases.productName.rawValue, isEqualTo: name).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}

            snapshot.documentChanges.forEach { diff in
                if diff.type == .removed {
                    guard let removed = DatabaseManager.PreOrder(dictionary: diff.document.data()) else {return}
                    success(removed)
                }
            }
        }
    }
    
}


//MARK: - Out of Class
//MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
