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
    
//MARK: Системные переменные
    static let shared = NetworkManager()
    
    
    let db = Firestore.firestore()
    
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
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: Получение всех сообщений  для чата сотрудников
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
//  Это для чата.
//  Set в Firebase работает отлично. Сетит мне данные о сообщении по шаблону, который находится в database. А сам метод пока что находится в WorkersChatViewController на 135 позиции.( //MARK: Метод-Алерт для сообщения )
//  На breakpoint'е показывает, что информации нет, когда я ее пытаюсь достать из firebase. Хотя метод вроде верный. По-крайне мере не вижу ошибки. Делал как и раньше
//  Когда в DatabaseManager я вместе " guard let name = dictionary[DatabaseManager.ChatMessagesCases.name.rawValue] as? String ... else {return nil} " ставлю " let name = dictionary[DatabaseManager.ChatMessagesCases.name.rawValue] as! String ... " , то мне выдает Fatal Error, но я успеваю увидеть в консоли, что кусочек информации о сообщени вытянулся.
//  DatabaseManager.ChatMessages сделал по аналогии, как и другие. Все String у меня через специальный enum для соответствующих нужд, что не ошибиться, когда их печают (как в прошлый раз).
//  Но я раньше не делал init шаблона с Date, но timeStamp в firebase НЕ nil, и помеченно как "временная метка", то есть как Date
//  Пример: DatabaseManager.ChatMessagesCases.name.rawValue
//  "workersMessages" написан правильно, как и в firebase.
    
//MARK: СПОСОБ ВХОДА В ЧАТ:
/// run app ->  menu ->  "FEEDBACK" -> Опустить вниз до "Отзыв":
    /// строка "Введите имя":
    // /WorkSpace
    /// строка "Введите отзыв":
    // Go/
    /// -> login: test@test.com  pass: 123456  ->  Вверху справа Чат.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    
}

extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
