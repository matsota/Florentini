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
    
    //MARK: - Для Админа:
    
    //MARK: - Метод загрузки Фотографии продукта в Firebase
    func productCreation(image: UIImageView, name: String, price: Int, description: String, category: String, stock: Bool, progressIndicator: UIProgressView) {
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
            self.setProductDescription(name: name, price: price, description: description, category: category, stock: stock)
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
    
    
    //MARK: - Для Сотрудников:
        
    //MARK: - Архивирование заказов
    func archiveOrder(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, orderKey: String, deliveryPerson: String){
        
        let data =  DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: orderKey, deliveryPerson: deliveryPerson)
        
        db.collection(NavigationCases.ArchiveCases.archivedOrders.rawValue).addDocument(data: data.dictionary)
        archiveOrderAddition(orderKey: orderKey)
    }
    
    //MARK: Архивирование описания заказов
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
                self.db.collection(NavigationCases.ArchiveCases.archivedOrderAdditions.rawValue).addDocument(data: jsonArray.remove(at: 0))
            }
        })
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(orderKey).delete()
        deleteAdditions(collection: docRef.collection(orderKey))
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
    
    //MARK: - Для пользователей:
    
    //MARK: - Отправка отзыва
    func sendReview(name: String, content: String) {
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newReview = DatabaseManager.ChatMessages(name: name, content: content, uid: "\(currentDeviceID)", timeStamp: Date())
        
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
        guard let currentDeviceID = CoreDataManager.shared.device else {return}
        let newOrder = DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: "\(currentDeviceID)", deliveryPerson: "none")
        
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).document("\(currentDeviceID)").setData(newOrder.dictionary) {
            error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                self.db.collection(NavigationCases.UsersInfoCases.order.rawValue).document("\(currentDeviceID)").collection("\(currentDeviceID)").document().setData(productDescription)
                success()
            }
        }
    }
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: - Информация о Сотрудниках
    func downloadEmployerInfo (success: @escaping([DatabaseManager.WorkerInfo]) -> Void, failure: @escaping(Error) -> Void) {
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
    
    //MARK: - Для Админа:
    
    //MARK: - Статистические данные об Архивированных заказах
    func fetchArchivedOrders(success: @escaping(_ receipts: [DatabaseManager.Order],_ additions: [DatabaseManager.OrderAddition], _ deleted: [DatabaseManager.Order]) -> Void, failure: @escaping(Error) -> Void) {
        //  - first fetch
        db.collection(NavigationCases.ArchiveCases.archivedOrders.rawValue).getDocuments {
            (querySnapshot, _) in
            let receiptsData = querySnapshot!.documents.compactMap{DatabaseManager.Order(dictionary: $0.data())}
            // - second fetch
            self.db.collection(NavigationCases.ArchiveCases.archivedOrderAdditions.rawValue).getDocuments {
                (querySnapshot, _) in
                let additionsData = querySnapshot!.documents.compactMap{DatabaseManager.OrderAddition(dictionary: $0.data())}
                //third fetch
                self.db.collection(NavigationCases.ArchiveCases.deletedOrders.rawValue).getDocuments { (querySnapshot, _) in
                    let deletedData = querySnapshot!.documents.compactMap{DatabaseManager.Order(dictionary: $0.data())}
                    success(receiptsData, additionsData, deletedData)
                }
            }
        }
    }
    
    //MARK: - Подкачать изображения по Ссылке в приложение
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
    
    //MARK: - Для Сотрудников:
    
    //MARK: - Подкачать заказ
    func downloadMainOrderInfo(success: @escaping([DatabaseManager.Order]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let orders = querySnapshot!.documents.compactMap{DatabaseManager.Order(dictionary: $0.data())}
            success(orders)
        })
    }
    
    //MARK: - Подкачать дополнение к заказу
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
    
    //MARK: - Общее:
    
    //MARK: - Подкачать Все товары
    func downloadProducts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Подкачать Букеты
    func downloadBouquets(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.bouquet.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Подкачать Цветы поштучно
    func downloadApieces(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.apiece.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Подкачать Подарки
    func downloadGifts(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.productCategory.rawValue, isEqualTo: NavigationCases.ProductCategoriesCases.gift.rawValue).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    //MARK: - Подкачать Акционные товары
    func downloadStocks(success: @escaping([DatabaseManager.ProductInfo]) -> Void, failure: @escaping(Error) -> Void) {
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).whereField(NavigationCases.ProductCases.stock.rawValue, isEqualTo: true).getDocuments(completion: {
            (querySnapshot, _) in
            let productInfo = querySnapshot!.documents.compactMap{DatabaseManager.ProductInfo(dictionary: $0.data())}
            success(productInfo)
        })
    }
    
    ///
    //MARK: - crUd
    ///
    
    //MARK: - Для Сотрудников:
    
    //MARK: - Редактирование цены существующего продукта в Worker-Catalog
    func editProductPrice(name: String, newPrice: Int) {
        let path = db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name)
        path.updateData([NavigationCases.ProductCases.productPrice.rawValue : newPrice])
    }
    
    //MARK: - Изменение Состояния акции
    func editStockCondition(name: String, stock: Bool) {
        let path = db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name)
        path.updateData([NavigationCases.ProductCases.stock.rawValue : stock])
    }
    
    //MARK: - Назначение Курьера
    func editDeliveryMan(currentDeviceID: String, deliveryPerson: String) {
        let path = db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(currentDeviceID)
        path.updateData([NavigationCases.UsersInfoCases.deliveryPerson.rawValue : deliveryPerson])
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
    

    
    ///
    //MARK: - cruD
    ///
    
    //MARK: - Сотрудники:
    
    //MARK: - Метод удаления продукта из базы данных
    func deleteProduct(name: String){
        db.collection(NavigationCases.ProductCases.imageCollection.rawValue).document(name).delete() { err in
            if let err = err {
                print("Error removing document: \(err.localizedDescription)")
            } else {
                let imageRef = Storage.storage().reference().child("\(NavigationCases.ProductCases.imageCollection.rawValue)/\(name)")
                imageRef.delete { error in
                    if let error = error {
                        print("error ocured: \(error.localizedDescription)")
                    } else {
                        print("Delete succeed")
                    }
                }
            }
        }
    }
    
    //MARK: - Удаление Описания Заказа
    func deleteAdditions(collection: CollectionReference, batchSize: Int = 100) {
        collection.limit(to: batchSize).getDocuments { (docs, error) in
            let docs = docs,
            batch = collection.firestore.batch()
            
            docs?.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { _ in
                self.deleteAdditions(collection: collection, batchSize: batchSize)
            }
        }
    }
    
    //MARK: - Удаление заказа
    func deleteNotForArchive(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, orderKey: String, deliveryPerson: String) {
        db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(orderKey).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                let data =  DatabaseManager.Order(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, currentDeviceID: orderKey, deliveryPerson: deliveryPerson),
                docRef = self.db.collection(NavigationCases.UsersInfoCases.order.rawValue).document(orderKey)
                
                self.db.collection(NavigationCases.ArchiveCases.deletedOrders.rawValue).addDocument(data: data.dictionary)
                self.deleteAdditions(collection: docRef.collection(orderKey))
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
