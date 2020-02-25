//
//  DatabaseManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
//MARK: Шаблон для информации о Сотруднике
    struct WorkerInfo {
        var name: String
        var position: String

        var dictionary: [String:Any]{
            return [
                DatabaseManager.WorkerInfoCases.name.rawValue: name,
                DatabaseManager.WorkerInfoCases.position.rawValue: position
            ]
        }
    }
    
//MARK: Шаблон для информации о Чате
    struct ChatMessages {
        var name: String
        var content: String
        var uid: String
        var timeStamp: Date
        
        var dictionary: [String:Any] {
            return [
                DatabaseManager.ChatMessagesCases.name.rawValue: name,
                DatabaseManager.ChatMessagesCases.content.rawValue: content,
                DatabaseManager.ChatMessagesCases.uid.rawValue: uid,
                DatabaseManager.ChatMessagesCases.timeStamp.rawValue: timeStamp
            ]
        }
    }
    
}


//MARK: Протокол шаблонов
protocol DocumentSerializable {
    init?(dictionary: [String:Any])
}


//MARK: Extensions

///MARK: О сотрудниках
extension DatabaseManager.WorkerInfo: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary[DatabaseManager.WorkerInfoCases.name.rawValue] as? String,
            let position = dictionary[DatabaseManager.WorkerInfoCases.position.rawValue] as? String else {return nil}
        self.init(name: name, position: position)
    }
}

///MARK:  Про чат
extension DatabaseManager.ChatMessages: DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let name = dictionary[DatabaseManager.ChatMessagesCases.name.rawValue] as? String,
            let content = dictionary[DatabaseManager.ChatMessagesCases.content.rawValue] as? String,
            let uid = dictionary[DatabaseManager.ChatMessagesCases.uid.rawValue] as? String,
            let timeStamp = dictionary["\(DatabaseManager.ChatMessagesCases.timeStamp.rawValue)"] as? Date else {return nil}
        self.init(name: name, content: content, uid: uid, timeStamp: timeStamp)
    }
}


//MARK: Cases
extension DatabaseManager {
    
///MARK: О сотрудниках
    enum WorkerInfoCases: String, CaseIterable {
        case name = "name"
        case position = "position"
    }
    
///MARK:  Про чат
    enum ChatMessagesCases: String, CaseIterable {
        case name = "name"
        case content = "content"
        case uid = "uid"
        case timeStamp = "timeStamp"
    }
    
}
