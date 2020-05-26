//
//  CartViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI
import CoreData


class CartViewController: UIViewController {
    
    //MARK: - Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        CoreDataManager.shared.cartIsEmpty(bar: self.tabBarItem)
        
        CoreDataManager.shared.fetchPreOrder(success: { (preOrderEntity) -> (Void) in
            self.preOrder = preOrderEntity
            
            if self.preOrder.count == 0 {
                self.tableCountZeroView.isHidden = false
            }else{
                self.tableCountZeroView.isHidden = true
            }
            
            self.orderBill = self.preOrder.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
            self.orderPriceLabel.text = "\(self.orderBill) грн"
            self.cartTableView.reloadData()
        }) { (error) in
            self.present(UIAlertController.completionDoneTwoSec(title: "Ошибка!", message: "Что-то пошло не так"), animated: true)
            print(error.localizedDescription)
        }
        
        CoreDataManager.shared.fetchClientData(success: { (client) -> (Void) in
            self.name = client.map({$0.name!}).first
            self.phone = client.map({$0.phone!}).first
            self.clientNameTextField.text = self.name
            self.clientCellPhoneTextField.text = self.phone
            if self.name != nil, self.phone != nil {
                self.clientsDataRemembered.text = "Обновить Ваше имя или телефон?"
            }
        }) { (error) in
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Не получилось подтянуть ваши Имя и телефон из памяти"), animated: true)
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: - Cart button tapped
    @IBAction private func feedBackBlankTapped(_ sender: Any) {
        feedBackTopConstraint.constant = hideAndShowFeedbackBlank()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Feedback button tapped
    @IBAction private func feedbackTypeSelectorTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showFeedbackOptions(option: sender)
    }
    
    //MARK: - Feedback selected
    @IBAction private func feedbackSelection(_ sender: DesignButton) {
        feedbackSelected(by: sender)
    }
    
    //MARK: - Hide feedback form
    @IBAction private func emptyButtonForHideTapped(_ sender: Any) {
        feedBackTopConstraint.constant = hideAndShowFeedbackBlank()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Order confirmation
    @IBAction private func confirmTapped(_ sender: UIButton) {
        performConfirmation()
    }
    
    //MARK: - Private Implementation
    private var preOrder = [PreOrderEntity]()
    
    private var name: String?
    private var phone: String?
    
    private var feedbackOption: String?
    private var orderBill = Int64()
    
    //MARK: Views
    @IBOutlet private weak var buttonsView: UIView!
    @IBOutlet private weak var tableCountZeroView: UIView!
    
    //MARK: StackView
    @IBOutlet private weak var billStackView: UIStackView!
    
    //MARK: Scroll View
    @IBOutlet weak var feedbackBlankScrollView: UIScrollView!
    
    //MARK: TableView Outlets
    @IBOutlet private weak var cartTableView: UITableView!
    
    //MARK: TextFields Outlets
    @IBOutlet private weak var clientNameTextField: UITextField!
    @IBOutlet private weak var clientCellPhoneTextField: UITextField!
    @IBOutlet private weak var clientAdressTextField: UITextField!
    @IBOutlet private weak var clientDescriptionTextField: UITextField!
    
    //MARK: Label
    @IBOutlet private weak var orderPriceLabel: UILabel!
    @IBOutlet private weak var clientsDataRemembered: UILabel!
    
    //MARK: Buttons Outlets
    @IBOutlet private var feedbackTypeBttnsCellection: [UIButton]!
    @IBOutlet private weak var feebackTypeSelectorButton: UIButton!
    @IBOutlet private weak var emptyButtonForHide: UIButton!
    @IBOutlet private weak var feedBackBlankButton: DesignButton!
    
    //MARK: - Switch
    @IBOutlet private weak var savingClientsDataSwitch: UISwitch!
    
    
    
    //MARK: Constrains Outlets
    @IBOutlet private weak var lowestConstraint: NSLayoutConstraint!
    @IBOutlet private weak var feedBackTopConstraint: NSLayoutConstraint!
    
}









//MARK: - Extention

//MARK: - by Table View
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.CartTVCell.rawValue, for: indexPath) as! CartTableViewCell
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        let fetch = preOrder[cell.tag],
        name = fetch.value(forKey: NavigationCases.Product.productName.rawValue) as! String,
        category = fetch.value(forKey: NavigationCases.Product.productCategory.rawValue) as! String,
        price = fetch.value(forKey: NavigationCases.Product.productPrice.rawValue) as! Int,
        sliderValue = fetch.value(forKey: NavigationCases.Product.productQuantity.rawValue) as! Int,
        stock = fetch.value(forKey: NavigationCases.Product.stock.rawValue) as! Bool
        
        guard let imageData = fetch.productImage else {return cell}
        
        cell.fill(name: name, category: category, price: price, slider: sliderValue, stock: stock, imageData: imageData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "X") { (action, view, complition) in
            CoreDataManager.shared.productDismiss(deleteWhere: self.preOrder, at: indexPath)
            self.preOrder.remove(at: indexPath.row)
            self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
            self.orderBill = self.preOrder.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
            self.orderPriceLabel.text = "\(self.orderBill) грн"
            self.cartTableView.reloadData()
            complition(true)
        }
        action.backgroundColor = .red
        return action
    }
    
}

//MARK: - Slider Values & Receipt changes
extension CartViewController: CartTableViewCellDelegate {
    
    func sliderValue(_ cell: CartTableViewCell) {
        guard let price = cell.productPrice, let name = cell.productName, let fetch = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        
        let sliderEquantion = Int(cell.quantitySlider.value) * price,
        sliderValue = Int(cell.quantitySlider.value)
        
        cell.productPriceLabel.text! = "\(sliderEquantion) грн"
        cell.quantityLabel.text! = "\(sliderValue) шт"
        
        CoreDataManager.shared.cartUpdate(name: name, quantity: sliderValue)
        
        self.orderBill = fetch.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
        self.orderPriceLabel.text = "\(self.orderBill) грн"
    }
    
}

//MARK: - Hide And Show Any
private extension CartViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        self.billStackView.isHidden = true
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        lowestConstraint.constant = keyboardFrameValue.cgRectValue.height * 0.9
        self.emptyButtonForHide.isHidden = true
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.billStackView.isHidden = false
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        lowestConstraint.constant = 14
        if self.feedbackBlankScrollView.isHidden == true {
            self.emptyButtonForHide.isHidden = true
        }else{
            self.emptyButtonForHide.isHidden = false
        }
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideAndShowFeedbackBlank() -> CGFloat {
        
        
        let up = UIImage(systemName: "chevron.up"),
        down = UIImage(systemName: "chevron.down")
        
        var height = self.feedBackTopConstraint.constant
        if  height == 0.0 {
            self.emptyButtonForHide.isHidden = false
            self.feedbackBlankScrollView.isHidden = false
            height = -self.cartTableView.bounds.height
            self.feedBackBlankButton.alpha = 1
            self.feedBackBlankButton.setImage(down, for: .normal)
        }else{
            height = 0.0
            self.emptyButtonForHide.isHidden = true
            self.feedbackBlankScrollView.isHidden = true
            self.feedBackBlankButton.alpha = 0.6
            self.feedBackBlankButton.setImage(up, for: .normal)
        }
        return height
    }
    
    func feedbackSelected(by sender: UIButton) {
        guard let title = sender.currentTitle, let feedbackType = NavigationCases.Feedback(rawValue: title) else {return}
        let cellphone = NavigationCases.Feedback.cellphone.rawValue,
        viber = NavigationCases.Feedback.viber.rawValue,
        telegram = NavigationCases.Feedback.telegram.rawValue
        
        switch feedbackType {
        case .cellphone:
            showFeedbackOptions(option: cellphone)
        case .viber:
            showFeedbackOptions(option: viber)
        case .telegram:
            showFeedbackOptions(option: telegram)
        }
    }
    
    func showFeedbackOptions(option: String) {
        feedbackOption = option
        feedbackTypeBttnsCellection.forEach { (buttons) in
            UIView.animate(withDuration: 0.2) {
                buttons.isHidden = !buttons.isHidden
                self.buttonsView.layoutIfNeeded()
            }
        }
        feebackTypeSelectorButton.setTitle(option, for: .normal)
    }
    
}

//MARK: - Send order from CoreData to Firebase
private extension CartViewController {
    
    func performConfirmation() {
        guard let name = self.clientNameTextField.text, let phone = self.clientCellPhoneTextField.text, let adress = self.clientAdressTextField.text else {return}
        var mark = self.clientDescriptionTextField.text!
        
        if self.feedbackOption == nil && mark == "" {
            self.feedbackOption = NavigationCases.Feedback.cellphone.rawValue
            mark = "Без Дополнений"
        }
        
        if name == "" || phone == "" || adress == "" {
            self.present(UIAlertController.completionDoneTwoSec(title: "Эттеншн!", message: "Мы не знаем всех необходимых данных, что бы осуществить доставку радости. Просим Вас ввести: Имя, Телефон, Адресс доставки, чтобы мы смогли подтвердить заказ"), animated: true)
            hideAndShowFeedbackBlank()
//            feedBackTopConstraint.constant = hideAndShowFeedbackBlank()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else if self.preOrder == [] {
            self.present(UIAlertController.completionDoneTwoSec(title: "Эттеншн!", message: "Вы не выбрали ни единого товара"), animated: true)
        }else{
            guard let currentDeviceID = CoreDataManager.shared.device else {return}
            let clientData = DatabaseManager.ClientInfo(name: name, phone: phone, orderCount: 1, deviceID: "\(currentDeviceID)", lastAdress: adress)
            
            NetworkManager.shared.updateClientData(clientData: clientData, success: {
                print("SUCCESS ADDED OR UPDATE")
            }) { (error) in
                print("ERROR: orderConfirm/ updateClientData :",error)
            }
            
            let sendAnOrder = {
                var jsonArray: [[String: Any]] = []
                for i in self.preOrder {
                    i.productImage = nil
                    let preOrderJSON = i.toJSON()
                    jsonArray.append(preOrderJSON)
                }
                
                let totalPrice = self.orderBill
                
                NetworkManager.shared.orderConfirm(totalPrice: totalPrice, name: name, adress: adress, cellphone: phone, feedbackOption: self.feedbackOption!, mark: mark, timeStamp: Date(), success: { ref in
                    for _ in self.preOrder {
                        NetworkManager.shared.orderDescriptionConfirm(path: ref.documentID, orderDescription: jsonArray.remove(at:0))
                    }
                    
                    self.present(UIAlertController.completionDoneTwoSec(title: "Ваш заказ оформлен", message: "Мы свяжемся с Вам так скоро, как это возможно"), animated: true)
                    self.clientAdressTextField.text = ""
                    self.clientDescriptionTextField.text = ""
                    self.orderPriceLabel.text = "0 грн"
                    self.tableCountZeroView.isHidden = false
                    self.feedBackTopConstraint.constant = 0
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    
                    CoreDataManager.shared.deleteAllData(entity: NavigationCases.CoreDataCases.PreOrderEntity.rawValue, success:  {
                        self.preOrder.removeAll()
                        self.cartTableView.reloadData()
                        self.tableCountZeroView.isHidden = false
                    }) { error in
                        self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Состояние вашего заказа не изменилось"), animated: true)
                    }
                }) { (error) in
                    self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Проблема с подключением к сети"), animated: true)
                    print("Error in CartViewController, func confirm(): ", error.localizedDescription)
                }
            }
            
            if self.savingClientsDataSwitch.isOn == true {
                CoreDataManager.shared.deleteAllData(entity: NavigationCases.CoreDataCases.ClientData.rawValue, success: {
                    guard let name = self.clientNameTextField.text, let phone = self.clientCellPhoneTextField.text else {
                        self.present(UIAlertController.completionDoneTwoSec(title: "Эттеншн!", message: "Мы не знаем всех необходимых данных, что бы осуществить доставку радости. Просим Вас ввести: Имя, Телефон, Адресс доставки, чтобы мы смогли подтвердить заказ"), animated: true)
                        return
                    }
                    CoreDataManager.shared.saveClientInfo(name: name, phone: phone, success: {
                        sendAnOrder()
                    }) {
                        self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Произошла ошибка в процессе обновления вашего Имени и телефона"), animated: true)
                    }
                }) { (error) in
                    self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Произошла ошибка в процессе изменения вашего Имени и телефона"), animated: true)
                    print(error.localizedDescription)
                }
            }else{
                sendAnOrder()
            }
        }
    }
    
}




