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
}

extension NetworkManager {
    enum NetworkManagerError: Error {
        case workerNotSignedIn
    }
}
