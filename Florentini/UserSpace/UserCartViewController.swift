//
//  UserCartViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI
import CoreData


class UserCartViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        
    }
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func menuTapped(_ sender: UIButton) {
        slideMethod(for: transitionView, constraint: transitionViewLeftConstraint, dismissBy: transitionDismissButton)
    }
    
    //MARK: - Transition seletion
    @IBAction func transitionAccepted(_ sender: UIButton) {
        guard let title = sender.currentTitle,
        let view = transitionView,
        let constraint = transitionViewLeftConstraint,
        let button = transitionDismissButton else {return}

        transitionPerform(by: title, for: view, with: constraint, dismiss: button)
    }
    
    //MARK: - Transition Dismiss
    @IBAction func transitionDismissTapped(_ sender: UIButton) {
        slideMethod(for: self.transitionView, constraint: self.transitionViewLeftConstraint, dismissBy: self.transitionDismissButton)
    }
    
    //MARK: - Cart button Tapped
    @IBAction private func feedBackBlankTapped(_ sender: Any) {
        feedBackTopConstraint.constant = hideAndShowFeedbackBlank()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Feedback button Tapped
    @IBAction private func feedbackTypeSelectorTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showFeedbackOptions(option: sender)
    }
    
    //MARK: - Feedback Selected
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
        confirm()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private var preOrder = [PreOrderEntity]()
    
    private var selectedFeedbackType = String()
    private var orderBill = Int64()
    
    //MARK: - Views
    @IBOutlet private weak var feedbackBlankView: UIView!
    @IBOutlet private weak var buttonsView: UIView!
    @IBOutlet private weak var tableCountZeroView: UIView!
    @IBOutlet private weak var transitionView: UIView!
    
    //MARK: - StackView
    @IBOutlet private weak var billStackView: UIStackView!
    
    //MARK: - ScrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: - TableView Outlets
    @IBOutlet private weak var cartTableView: UITableView!
    
    //MARK: - TextFields Outlets
    @IBOutlet private weak var clientNameTextField: UITextField!
    @IBOutlet private weak var clientCellPhoneTextField: UITextField!
    @IBOutlet private weak var clientAdressTextField: UITextField!
    @IBOutlet private weak var clientDescriptionTextField: UITextField!
    @IBOutlet private weak var orderPriceLabel: UILabel!
    
    //MARK: - Buttons Outlets
    @IBOutlet private var feedbackTypeBttnsCellection: [UIButton]!
    @IBOutlet private weak var feebackTypeSelectorButton: UIButton!
    @IBOutlet private weak var emptyButtonForHide: UIButton!
    @IBOutlet private weak var feedBackBlankButton: DesignButton!
    @IBOutlet private weak var transitionDismissButton: UIButton!
    
    
    //MARK: - Constrains Outlets
    @IBOutlet private weak var lowestConstraint: NSLayoutConstraint!
    @IBOutlet private weak var feedBackTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var transitionViewLeftConstraint: NSLayoutConstraint!
    
}









//MARK: - Extention

//MARK: - For Overrides
private extension UserCartViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        
        CoreDataManager.shared.fetchPreOrder { (preOrderEntity) -> (Void) in
            self.preOrder = preOrderEntity
            
            if self.preOrder.count == 0 {
                self.tableCountZeroView.isHidden = false
            }else{
                self.tableCountZeroView.isHidden = true
            }
            
            self.orderBill = self.preOrder.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
            self.orderPriceLabel.text = "\(self.orderBill) грн"
            self.cartTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
}

//MARK: - by Table View
extension UserCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.UsersCartTVCell.rawValue, for: indexPath) as! UserCartTableViewCell
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        let fetch = preOrder[cell.tag],
        name = fetch.value(forKey: NavigationCases.ProductCases.productName.rawValue) as! String,
        category = fetch.value(forKey: NavigationCases.ProductCases.productCategory.rawValue) as! String,
        price = fetch.value(forKey: NavigationCases.ProductCases.productPrice.rawValue) as! Int,
        sliderValue = fetch.value(forKey: NavigationCases.ProductCases.productQuantity.rawValue) as! Int,
        stock = fetch.value(forKey: NavigationCases.ProductCases.stock.rawValue) as! Bool
        
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
            CoreDataManager.shared.deleteFromCart(deleteWhere: self.preOrder, at: indexPath)
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

//MARK: -

//MARK: - Slider Values & Receipt changes
extension UserCartViewController: UserCartTableViewCellDelegate {
    
    func sliderValue(_ cell: UserCartTableViewCell) {
        guard let price = cell.productPrice, let name = cell.productName, let fetch = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        
        let sliderEquantion = Int(cell.quantitySlider.value) * price,
        sliderValue = Int(cell.quantitySlider.value)
        
        cell.productPriceLabel.text! = "\(sliderEquantion) грн"
        cell.quantityLabel.text! = "\(sliderValue) шт"
        
        CoreDataManager.shared.updateCart(name: name, quantity: sliderValue)
        
        self.orderBill = fetch.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
        self.orderPriceLabel.text = "\(self.orderBill) грн"
    }
    
}

//MARK: - Hide And Show Any
private extension UserCartViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        self.billStackView.isHidden = true
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
                lowestConstraint.constant = keyboardFrameValue.cgRectValue.height * 0.9
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.billStackView.isHidden = false
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
                lowestConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideAndShowFeedbackBlank() -> CGFloat {
        let up = UIImage(systemName: "chevron.up"),
        down = UIImage(systemName: "chevron.down")
        
        var height = self.feedBackTopConstraint.constant
        if  height == 0.0 {
            height = -self.cartTableView.frame.height
            self.feedBackBlankButton.setImage(down, for: .normal)
        }else{
            height = 0.0
            self.feedBackBlankButton.setImage(up, for: .normal)
        }
        return height
    }
    
    func feedbackSelected(by sender: UIButton) {
        guard let title = sender.currentTitle, let feedbackType = NavigationCases.FeedbackTypesCases(rawValue: title) else {return}
        let cellphone = NavigationCases.FeedbackTypesCases.cellphone.rawValue,
        viber = NavigationCases.FeedbackTypesCases.viber.rawValue,
        telegram = NavigationCases.FeedbackTypesCases.telegram.rawValue
        
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
        selectedFeedbackType = option
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
private extension UserCartViewController {
    
    func confirm() {
        guard let adress = clientAdressTextField.text, let cellphone = clientCellPhoneTextField.text else {return}
        
        var name = clientNameTextField.text!,
        mark = clientDescriptionTextField.text!,
        feedbackOption = selectedFeedbackType
        
        if feedbackOption == "", name == "", mark == "" {
            feedbackOption = NavigationCases.FeedbackTypesCases.cellphone.rawValue
            name = "Без Имени"
            mark = "Без Дополнений"
        }
        
        if adress == "" || cellphone == "" {
            self.present(UIAlertController.classic(title: "Эттеншн!", message: "Мы не знаем всех необходимых данных, что бы осуществить доставку радости. Просим Вас ввести: Адресс доставки и Телефон, чтобы мы смогли подтвердить заказ"), animated: true)
        }else{
            var jsonArray: [[String: Any]] = []
            
            for i in preOrder {
                i.productImage = nil
                let preOrderJSON = i.toJSON()
                jsonArray.append(preOrderJSON)
            }
            print(jsonArray)
            
            let totalPrice = orderBill
            
            for _ in preOrder {
                NetworkManager.shared.sendOrder(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: Date(), productDescription: jsonArray.remove(at:0), success: {
                    
                    self.present(UIAlertController.completionDoneTwoSec(title: "Ваш заказ оформлен", message: "Мы свяжемся с Вам так скоро, как это возможно"), animated: true)
                    self.clientNameTextField.text = ""
                    self.clientAdressTextField.text = ""
                    self.clientCellPhoneTextField.text = ""
                    self.clientDescriptionTextField.text = ""
                    CoreDataManager.shared.deleteAllData(entity: NavigationCases.UsersInfoCases.PreOrderEntity.rawValue) {
                        self.preOrder.removeAll()
                        self.cartTableView.reloadData()
                    }
                }) { (error) in
                    self.present(UIAlertController.somethingWrong(), animated: true)
                    print("Error in CartViewController, func confirm(): ", error.localizedDescription)
                }
            }
        }
    }
    
}




