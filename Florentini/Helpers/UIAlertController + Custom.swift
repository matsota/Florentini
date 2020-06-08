//
//  UIAlertController + Custom.swift
//  CleanUp
//
//  Created by Andrew Matsota on 27.12.2019.
//  Copyright © 2019 Andrew Matsota. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    //MARK: - Classic Alert with only "ОК" button and empty title&message
    static func classic (title: String, message: String) -> (UIAlertController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
    //MARK: - Classic Alert with only "ОК" button for some error
    static func somethingWrong() -> (UIAlertController){
        let alertController = UIAlertController(title: "Упс!", message: "Что-то пошло не так", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    

    
    ///
    //MARK: - Crud
    ///
    
    ///
    //MARK: - cRud
    ///
    
    //MARK: Half sec
    static func completionDoneHalfSec(title: String, message: String) -> (UIAlertController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        return alert
    }
    
    //MARK: Two sec
    static func completionDoneTwoSec(title: String, message: String) -> (UIAlertController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
        return alert
    }
    
    ///
    //MARK: - crUd
    ///
    
    ///
    //MARK: - cruD
    ///
    //MARK: - Sign Out Method
    static func signOut(success: @escaping() -> Void) -> (UIAlertController) {
        let alertSignOut = UIAlertController(title: "Внимание", message: "Подтвердите, что вы нажали на \"Выход\" неслучайно", preferredStyle: .actionSheet)
        alertSignOut.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        alertSignOut.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            AuthenticationManager.shared.signOut()
            success()
        }))
        return (alertSignOut)
    }
}
