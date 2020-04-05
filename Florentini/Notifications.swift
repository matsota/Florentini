//
//  Notifications.swift
//  Florentini
//
//  Created by Andrew Matsota on 05.04.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import UserNotifications

//MARK: Подготовка для подписки
class Notifications {
    
    static let shared = Notifications()
    
    
    //MARK: - Запрос на уведомления
    static func permition() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: ", granted)
        }
    }
    
    //MARK: - Получение новый сообщений
    func newMessage(messageFrom: String, messageBody: String, messageSender: String) {
        
        let content = UNMutableNotificationContent(),
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        content.title = "У Вас новое сообщение от: \(messageFrom)"
        content.body = messageBody
        content.sound = UNNotificationSound.default
        
        if messageSender != messageFrom {
            let request = UNNotificationRequest(identifier: NavigationCases.Notification.newMessage.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
}
