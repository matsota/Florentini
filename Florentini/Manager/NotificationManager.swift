//
//  Notifications.swift
//  Florentini
//
//  Created by Andrew Matsota on 05.04.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func permitionRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: ", granted)
        }
    }
    
}
