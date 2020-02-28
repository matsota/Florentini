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
    
    //MARK: - Метод загрузки Фотографии продукта в Firebase
    
    func uploadPhoto(image: UIImage, name: String, complition: @escaping(String) -> Void) {
        let uidAdmin = "Q0Lh49RsIrMU8itoNgNJHN3bjmD2"
        guard uidAdmin == AuthenticationManager.shared.currentUser?.uid else {return}
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
            DatabaseManager.NewProductCases.productName.rawValue: name,
            DatabaseManager.NewProductCases.productPrice.rawValue: price,
            DatabaseManager.NewProductCases.productCategory.rawValue: category,
            DatabaseManager.NewProductCases.productDescription.rawValue: description,
            DatabaseManager.NewProductCases.productImageURL.rawValue: url
        ] as [String: Any]
           
        db.collection(DatabaseManager.NewProductCases.imageCollection.rawValue).document(documentNamedID).setData(imageTemplate, merge: true)
    }
    
}


    //MARK: - Out of Class
    //MARK: - Extensions
extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
