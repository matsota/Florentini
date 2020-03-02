//
//  NetworkManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import Firebase

class NetworkManager {
    
    //MARK: - Системные переменные
    static let shared = NetworkManager()
    let db = Firestore.firestore()


    //MARK: - Workers Dataload
    func workersInfoLoad (success: @escaping([DatabaseManager.WorkerInfo]) -> Void, failure: @escaping(Error) -> Void) {
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection("workers").document(AuthenticationManager.shared.currentUser!.uid).getDocument { (documentSnapshot, _) in
                let workerInfo = DatabaseManager.WorkerInfo(dictionary: documentSnapshot!.data()!)
                    success([workerInfo!])
            }
        }
    }
 

    //MARK: - Получение всех сообщений  для чата сотрудников
    func workersMessagesLoad(success: @escaping([DatabaseManager.ChatMessages]) -> Void, failure: @escaping(Error) -> Void) {
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
             db.collection("workersMessages").getDocuments(completion: {
                (querySnapshot, _) in
                let messages = querySnapshot!.documents.compactMap{DatabaseManager.ChatMessages(dictionary: $0.data())}
                success(messages)
                print(querySnapshot!.documents.compactMap{DatabaseManager.ChatMessages(dictionary: $0.data())})
                print(messages)
            })
        }
    }
    
    
    //MARK: - Отправка сообщения в Чате сотрудников

    func sendMessage(name: String, content: String) {
        let newMessage = DatabaseManager.ChatMessages(name: name, content: content, uid: AuthenticationManager.shared.currentUser!.uid, timeStamp: Date())
        var ref: DocumentReference? = nil
        
        ref = db.collection("workersMessages").addDocument(data: newMessage.dictionary) {
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
        db.collection("workersMessages").whereField(DatabaseManager.ChatMessagesCases.timeStamp.rawValue, isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
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
        if AuthenticationManager.shared.currentUser?.uid == nil {
            failure(NetworkManagerError.workerNotSignedIn)
        }else{
            db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).getDocuments(completion: {
                (querySnapshot, _) in
                let messages = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
                success(messages)
                print(querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())})
                print(messages)
            })
        }
    }
    
    //MARK: - Метод загрузки Фотографии продукта в Firebase
    func uploadPhoto(image: UIImage, name: String, complition: @escaping(String) -> Void) {
        
        guard AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid else {return}
        let storageRef =  Storage.storage().reference().child("ProductPhotos/\(name)")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/ipg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil {
                storageRef.downloadURL { (url, _) in
                    guard let url = url?.absoluteString else {return}
                    complition(url)
                }
            }
        }
    }
    
    //MARK: - Метод внесения информации  о товаре в Firebase
    func imageData(name: String, price: String, category: String, description: String, url: String, documentNamedID: String, complition: @escaping ((_ success: Bool) -> ())) {
        
        let imageTemplate = [
            DatabaseManager.ProductCases.productName.rawValue: name,
            DatabaseManager.ProductCases.productPrice.rawValue: price,
            DatabaseManager.ProductCases.productCategory.rawValue: category,
            DatabaseManager.ProductCases.productDescription.rawValue: description,
            DatabaseManager.ProductCases.productImageURL.rawValue: url
        ] as [String: Any]
           
        db.collection(DatabaseManager.ProductCases.imageCollection.rawValue).document(documentNamedID).setData(imageTemplate, merge: true)
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
    //MARK: - Метод Загрузки изображения из Галлереи в приложение
    //Врядли этот метод должен быть в НетворкМанаджере
    
//    //MARK: - Метод Загрузки изображения с Камеры в приложение
//    Не получается. НО! Врядли этот метод должен быть в НетворкМанаджере
//    func makePhoto(success: @escaping(UIImagePickerController) -> Void, error: @escaping(Error) -> Void) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            let image = UIImagePickerController()
//            image.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
//            image.sourceType = UIImagePickerController.SourceType.camera
//            image.allowsEditing = false
//
//            success(image)
//        }
//    }
}


    //MARK: - Out of Class
    //MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
