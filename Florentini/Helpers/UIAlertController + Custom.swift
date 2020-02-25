//
//  alerts.swift
//  CleanUp
//
//  Created by Andrew Matsota on 27.12.2019.
//  Copyright © 2019 Andrew Matsota. All rights reserved.
//

import UIKit

extension UIAlertController {

//MARK: Classic Alert с одной кнопкой "ОК" c возможностью кастомизировать Tittle&Message
    func alertClassicInfoOK (title: String, message: String) -> (UIAlertController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
    
        return (alertController)
    }

//MARK: Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
    func alertSomeThingGoesWrong() -> (UIAlertController){
        let alertController = UIAlertController(title: "Упс!", message: "Что-то пошло не так", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }

//MARK: Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
    func alertDataUnSaved() -> (UIAlertController){
        let alertController = UIAlertController(title: "Внимание!", message: "Дата НЕ сохранилась. Произошла Ошибка", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
    
        return (alertController)
    }
    
//MARK: Alert with 2 buttons and 2 textfields
    func alertCompose(title: String, message: String, textField1: String, textField2: String) -> (UIAlertController) {
        let alertCompose = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCompose.addTextField { (textField: UITextField) in
            textField.placeholder = textField1
        }
        alertCompose.addTextField { (textField: UITextField) in
            textField.placeholder = textField2
        }
        alertCompose.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertCompose.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: nil))
        return (alertCompose)
    }

    
    
//MARK: Authentication Alerts
//sign Up
    func alertSignOut(success: @escaping() -> Void) -> (UIAlertController) {
        let alertSignOut = UIAlertController(title: "Внимание", message: "Подтвердите, что вы нажали на \"Выход\" неслучайно", preferredStyle: .actionSheet)
        alertSignOut.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            AuthenticationManager.shared.signOut()
            success()
        }))
        alertSignOut.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return (alertSignOut)
    }

//pass change
    func alertPassChange(success: @escaping() -> Void, password: String) -> (UIAlertController) {
        let alertSignOut = UIAlertController(title: "Внимание", message: "Подтвердите смену пароля", preferredStyle: .actionSheet)
        alertSignOut.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            AuthenticationManager.shared.passChange(password: password)
            success()
        }))
        alertSignOut.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return (alertSignOut)
    }
    
//validate
    func alertSignUpFields() -> (UIAlertController){
        let alertController = UIAlertController(title: "Внимание!", message: "Необходимо заполнить все поля", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
    
        return (alertController)
    }
}
