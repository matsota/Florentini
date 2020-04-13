//
//  UIAlertController + Custom.swift
//  CleanUp
//
//  Created by Andrew Matsota on 27.12.2019.
//  Copyright © 2019 Andrew Matsota. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    //MARK: - Classic Alert с одной кнопкой "ОК" c возможностью кастомизировать Tittle&Message
    static func classic (title: String, message: String) -> (UIAlertController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
    //MARK: - Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
    static func somethingWrong() -> (UIAlertController){
        let alertController = UIAlertController(title: "Упс!", message: "Что-то пошло не так", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
//    //MARK: - Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
//    func savingFailure() -> (UIAlertController){
//        let alertController = UIAlertController(title: "Внимание!", message: "Дата НЕ сохранилась. Произошла Ошибка", preferredStyle: .alert)
//        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
//        alertController.addAction(action)
//
//        return (alertController)
//    }
    
//    //MARK: - Alert with 2 buttons and 2 textfields
//    func confirmSample(title: String, message: String, textField1: String, textField2: String) -> (UIAlertController) {
//        let alertCompose = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertCompose.addTextField { (textField: UITextField) in
//            textField.placeholder = textField1
//        }
//        alertCompose.addTextField { (textField: UITextField) in
//            textField.placeholder = textField2
//        }
//        alertCompose.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//        alertCompose.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: nil))
//        return (alertCompose)
//    }
    
    
    ///
    //MARK: - Crud
    ///
    
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
    
    //MARK: - Success Upload
    
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
}
