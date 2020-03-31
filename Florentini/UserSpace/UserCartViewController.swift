//
//  UserBasketViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI
import CoreData


class UserCartViewController: UIViewController {
    
    static let shared = UserCartViewController()
    
    //MARK: - Overrides
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK: -
    @IBAction func menuTapped(_ sender: UIButton) {
        showUsersSlideInMethod()
    }
    
    
    //MARK: - Нажатие кнопки Обратной связи
    @IBAction func feedbackTypeSelectorTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showOptionsMethod(option: sender)
    }
    
    @IBAction func feedbackTypeTapped(_ sender: DesignButton) {
        selectionMethod(self, sender)
    }
    
    //MARK: - Подтвреждение заказа
    @IBAction func confirmTapped(_ sender: UIButton) {
        confirm()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private var preOrder = [PreOrderEntity]()
    private let alert = UIAlertController()
    
    private var selectedFeedbackType = String()
    private var orderBill = Int64()
    
    //MARK: Views Outlets
    @IBOutlet private weak var buttonsView: UIView!
    @IBOutlet private weak var tableCountZeroView: UIView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    //MARK: TableView Outlets
    @IBOutlet private weak var cartTableView: UITableView!
    
    //MARK: TextFields Outlets
    @IBOutlet private weak var clientNameTextField: UITextField!
    @IBOutlet private weak var clientCellPhoneTextField: UITextField!
    @IBOutlet private weak var clientAdressTextField: UITextField!
    @IBOutlet private weak var clientDescriptionTextField: UITextField!
    @IBOutlet private weak var orderPriceLabel: UILabel!
    
    //MARK: Buttons Outlets
    @IBOutlet private var feedbackTypeBttnsCellection: [UIButton]!
    @IBOutlet private weak var feebackTypeSelectorButton: UIButton!
    
    
    //MARK: Constrains Outlets
    @IBOutlet private weak var lowestConstraint: NSLayoutConstraint!
    
}









//MARK: - Extention HomeViewControllerr

//MARK: - byextention by UIVC-TransitioningDelegate
extension UserCartViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
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
        price = fetch.value(forKey: NavigationCases.ProductCases.productPrice.rawValue) as! Int64,
        sliderValue = fetch.value(forKey: NavigationCases.ProductCases.productQuantity.rawValue) as! Int64,
        stock = fetch.value(forKey: NavigationCases.ProductCases.stock.rawValue) as! Bool,
        imageData = UserDefaults.standard.object(forKey: name) as! NSData
        
        if category == NavigationCases.ProductCategoriesCases.apiece.rawValue {
            cell.quantitySlider.maximumValue = Float(NavigationCases.MaxQuantityByCategoriesCases.hundred.rawValue)
        }
        if category == NavigationCases.ProductCategoriesCases.bouquet.rawValue {
            cell.quantitySlider.maximumValue = Float(NavigationCases.MaxQuantityByCategoriesCases.five.rawValue)
        }
        
        cell.fill (name: name , price: price, slider: sliderValue, stock: stock, imageData: imageData)
        
        return cell
    }
    
    // - Cell's method for delete in TableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "X") { (action, view, complition) in
            CoreDataManager.shared.deleteFromCart(deleteWhere: self.preOrder, at: indexPath)
            self.preOrder.remove(at: indexPath.row)
            self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
            self.viewDidLoad()
            complition(true)
        }
        action.backgroundColor = .red
        return action
    }
    
}


//MARK: -

//MARK: - Прокрутка слайдера для выбора количества + Метод (Изменение конечной стоимости продукта в зависимости от выбранного количества)
extension UserCartViewController: UserCartTableViewCellDelegate {
    
    func sliderValue(_ cell: UserCartTableViewCell) {
        guard let price = cell.productPrice, let name = cell.productName, let fetch = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        
        let sliderEquantion = Int64(cell.quantitySlider.value) * price,
        sliderValue = Int64(cell.quantitySlider.value)
        
        cell.productPriceLabel.text! = "\(sliderEquantion) грн"
        cell.quantityLabel.text! = "\(sliderValue) шт"
        
        CoreDataManager.shared.updateCart(name: name, quantity: sliderValue)
        
        self.orderBill = fetch.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
        self.orderPriceLabel.text = "\(self.orderBill) грн"
    }
    
}

//MARK: - Появление / Выбор вариантов обратной связи
private extension UserCartViewController {
    
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let feedbackType = NavigationCases.FeedbackTypesCases(rawValue: title) else {return}
        switch feedbackType {
        case .cellphone:
            showOptionsMethod(option: NavigationCases.FeedbackTypesCases.cellphone.rawValue)
        case .viber:
            showOptionsMethod(option: NavigationCases.FeedbackTypesCases.viber.rawValue)
        case .telegram:
            showOptionsMethod(option: NavigationCases.FeedbackTypesCases.telegram.rawValue)
        }
    }
    
    func showOptionsMethod(option: String) {
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

//MARK: - Смещение constrains при появлении клавиатуры
private extension UserCartViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        lowestConstraint.constant = keyboardFrameValue.cgRectValue.height * 0.9
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        lowestConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - Отправка предзаза из coredata в firebase
private extension UserCartViewController {
    
    func confirm() {
        guard let adress = clientAdressTextField.text, let cellphone = clientCellPhoneTextField.text else {return}
        let totalPrice = orderBill
        
        var name = clientNameTextField.text!,
        mark = clientDescriptionTextField.text!,
        feedbackOption = selectedFeedbackType
        
        //defaults
        if feedbackOption == "", name == "", mark == "" {
            feedbackOption = NavigationCases.FeedbackTypesCases.cellphone.rawValue
            name = "Без Имени"
            mark = "Без Дополнений"
        }
    
        if adress == "" || cellphone == "" {
            self.present(self.alert.alertClassicInfoOK(title: "Эттеншн!", message: "Мы не знаем всех необходимых данных, что бы осуществить доставку радости. Просим Вас ввести: Адресс доставки и Телефон, чтобы мы смогли подтвердить заказ"), animated: true)
        }else{
            var jsonArray: [[String: Any]] = []
            
            for i in preOrder {
                var dict: [String: Any] = [:]
                for attribute in i.entity.attributesByName {
                    if let value = i.value(forKey: attribute.key) {
                        dict[attribute.key] = value
                    }
                }
                jsonArray.append(dict)
            }
            
            for _ in preOrder {
                NetworkManager.shared.sendOrder(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: Date(), productDescription: jsonArray.remove(at:0)) {
                    self.present(self.alert.succeedFinish(title: "Ваш заказ оформлен", message: "Мы свяжемся с Вам так скоро, как это возможно"), animated: true)
                    self.viewDidLoad()
                    self.clientNameTextField.text = ""
                    self.clientAdressTextField.text = ""
                    self.clientCellPhoneTextField.text = ""
                    self.clientDescriptionTextField.text = ""
                }
            }
            
            CoreDataManager.shared.deleteAllData(entity: NavigationCases.UsersInfoCases.PreOrderEntity.rawValue) {
                self.preOrder.removeAll()
                self.cartTableView.reloadData()
            }
        }
    }
    
}




