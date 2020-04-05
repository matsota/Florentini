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
    func classic (title: String, message: String) -> (UIAlertController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
    //MARK: - Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
    func somethingWrong() -> (UIAlertController){
        let alertController = UIAlertController(title: "Упс!", message: "Что-то пошло не так", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
    //MARK: - Classic Alert с одной кнопкой "ОК" БЕЗ возможности кастомизировать Tittle&Message
    func savingFailure() -> (UIAlertController){
        let alertController = UIAlertController(title: "Внимание!", message: "Дата НЕ сохранилась. Произошла Ошибка", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",  style: .default) {(action) in}
        alertController.addAction(action)
        
        return (alertController)
    }
    
    //MARK: - Alert with 2 buttons and 2 textfields
    func confirmSample(title: String, message: String, textField1: String, textField2: String) -> (UIAlertController) {
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
    
    
    //MARK: - Sign Out Method
    func signOut(success: @escaping() -> Void) -> (UIAlertController) {
        let alertSignOut = UIAlertController(title: "Внимание", message: "Подтвердите, что вы нажали на \"Выход\" неслучайно", preferredStyle: .actionSheet)
        alertSignOut.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            success()
        }))
        alertSignOut.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return (alertSignOut)
    }
    
    //MARK: - Password change Method
    func rePassword(success: @escaping() -> Void, password: String) -> (UIAlertController) {
        let alertSignOut = UIAlertController(title: "Внимание", message: "Подтвердите смену пароля", preferredStyle: .actionSheet)
        alertSignOut.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            AuthenticationManager.shared.passChange(password: password)
            success()
        }))
        alertSignOut.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return (alertSignOut)
    }
    
    //MARK: - Send Message Method in Chat of WorkSpace
    func sendToChat(name: String) -> (UIAlertController) {
        
        let alertMessage = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        alertMessage.addTextField { (text:UITextField) in
            text.placeholder = "Введите сообщение"
        }
        
        alertMessage.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertMessage.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { (action: UIAlertAction) in
            if let content = alertMessage.textFields?.first?.text {
                NetworkManager.shared.newChatMessage(name: name, content: content)
            }
        }))
        return alertMessage
    }
    
    //MARK: - Alert Image from URL
    func uploadImageURL(success: @escaping(String) -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Добавить Изображение по Ссылке", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { (action: UIAlertAction) in
            let textField = alert.textFields?[0]
            success((textField?.text)!)
        }))
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Введите ссылку"
        }
        return alert
    }
    
    //MARK: - Delete Product
    func productDelete(name: String, success: @escaping() -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Подтвердите, что Вы желаете удалить продукт", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            NetworkManager.shared.deleteProduct(name: name)
            success()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return alert
    }
    
    //MARK: - Delete Order
    func orderArchive(totalPrice: Int64, name: String, adress: String, cellphone: String, feedbackOption: String, mark: String, timeStamp: Date, id: String, deliveryPerson: String, success: @escaping() -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Подтвердите, что Вы желаете отправить заказ в архив", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { _ in
            NetworkManager.shared.archiveOrder(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, orderKey: id, deliveryPerson: deliveryPerson)
            success()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return alert
    }
    
    //MARK: - Price editor
    func editProductPrice(name: String, success: @escaping(Int) -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Введите новую цену для этого продукта", preferredStyle: .alert)
            
        alert.addTextField { (text:UITextField) in
            text.keyboardType = .numberPad
            text.placeholder = "Введите сообщение"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { (action: UIAlertAction) in
            guard let newPrice = Int((alert.textFields?.first?.text)!)  else {return}
            NetworkManager.shared.editProductPrice(name: name, newPrice: newPrice)
            success(newPrice)
        }))
        return alert
    }
    
    //MARK: - Stock editor
    func editStockCondition(name: String, stock: Bool, compltion: () -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Подтвердите изменение наличия АКЦИИ", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { (action: UIAlertAction) in
            NetworkManager.shared.editStockCondition(name: name, stock: stock)
        }))
        return alert
    }
    
    func editDeliveryPerson(currentDeviceID: String, success: @escaping(String) -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Введите Имя человека, который будет доставлять этот заказ", preferredStyle: .alert)
            
        alert.addTextField { (text:UITextField) in
            text.placeholder = "Введите имя"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Подтвердить", style: .default, handler: { (action: UIAlertAction) in
            guard let deliveryPerson = alert.textFields?.first?.text else {return}
            NetworkManager.shared.editDeliveryMan(currentDeviceID: currentDeviceID, deliveryPerson: deliveryPerson)
            success(deliveryPerson)
        }))
        return alert
    }
    
    //MARK: - Success Upload
    func completionDone(title: String, message: String) -> (UIAlertController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
        return alert
    }
    
    //MARK: - Price editor
    func setNumber(success: @escaping(Int) -> Void) -> (UIAlertController) {
        let alert = UIAlertController(title: "Внимание", message: "Введите число относительно котогоро хотите отфильтровать", preferredStyle: .alert)
            
        alert.addTextField { (text:UITextField) in
            text.keyboardType = .numberPad
            text.placeholder = "Введите Число"
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { (action: UIAlertAction) in
            guard let newPrice = Int((alert.textFields?.first?.text)!)  else {return}
            success(newPrice)
        }))
        return alert
    }
}
