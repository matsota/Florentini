//
//  BasketViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI
import CoreData

class BasketViewController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: - var & let
    var preOrderArray = [DatabaseManager.PreOrder]()
    
    //MARK: - Overrides
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getPreOrder(success: { (preOrder) in
            self.preOrderArray = preOrder
            self.basketTableView.reloadData()
        }) { (error) in
            print("error: \(error.localizedDescription)")
            
        }
        
        //MARK: Keyboard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //
        
        
        
    }
    var orderBill: Int?
    
    //MARK: - Выбор Обратной связи
    @IBAction func feedbackTypeSelectorTapped(_ sender: UIButton) {
        hideAndShowButtons(option: DatabaseManager.FeedbackTypesCases.cellphone.rawValue)
    }
    @IBAction func feedbackTypeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let feedbackType = DatabaseManager.FeedbackTypesCases(rawValue: title) else {return}
        
        switch feedbackType {
        case .cellphone:
            hideAndShowButtons(option: DatabaseManager.FeedbackTypesCases.cellphone.rawValue)
            
            //            selectedFeedbackType = DatabaseManager.FeedbackTypesCases.cellphone.rawValue
            //
            //            feebackTypeSelectorButton.titleLabel?.text = DatabaseManager.FeedbackTypesCases.cellphone.rawValue
            print(selectedFeedbackType!)
        case .viber:
            hideAndShowButtons(option: DatabaseManager.FeedbackTypesCases.viber.rawValue)
            
            //            selectedFeedbackType = DatabaseManager.FeedbackTypesCases.viber.rawValue
            //
            //            feebackTypeSelectorButton.titleLabel?.text = DatabaseManager.FeedbackTypesCases.viber.rawValue
            print(selectedFeedbackType!)
        case .telegram:
            hideAndShowButtons(option: DatabaseManager.FeedbackTypesCases.telegram.rawValue)
            
            //            selectedFeedbackType = DatabaseManager.FeedbackTypesCases.telegram.rawValue
            //
            //            feebackTypeSelectorButton.titleLabel?.text = DatabaseManager.FeedbackTypesCases.telegram.rawValue
            print(selectedFeedbackType!)
        }
    }
    
    //MARK: - Подтвреждение заказа
    @IBAction func confirmTapped(_ sender: UIButton) {
    }
    
    //MARK: - Private
    //MARK: Views Outlets
    @IBOutlet weak private var buttonsView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: TableView Outlets
    @IBOutlet weak private var basketTableView: UITableView!
    
    //MARK: TextFields Outlets
    @IBOutlet weak private var clientNameTextField: UITextField!
    @IBOutlet weak private var clientPhoeNumberTextField: UITextField!
    @IBOutlet weak private var clientAdressTextField: UITextField!
    @IBOutlet weak private var clientDescriptionTextField: UITextField!
    @IBOutlet weak private var orderPriceLabel: UILabel!
    
    //MARK: Buttons Outlets
    @IBOutlet weak private var feebackTypeSelectorButton: UIButton!
    @IBOutlet private var feedbackTypeBttnsCellection: [UIButton]!
    
    //MARK: Constrains Outlets
    @IBOutlet weak private var lowestConstraint: NSLayoutConstraint!
    
    //MARK: - Приватные переменные
    private var selectedFeedbackType: String?
    
    var test = [DatabaseManager.PreOrderCorrection]()
    //MARK: - Приватные методы
    private func hideAndShowButtons(option: String){
        selectedFeedbackType = option
        feedbackTypeBttnsCellection.forEach { (buttons) in
            UIView.animate(withDuration: 0.2) {
                buttons.isHidden = !buttons.isHidden
                self.buttonsView.layoutIfNeeded()
            }
        }
        feebackTypeSelectorButton.titleLabel?.text = option
    }
    
    
    //MARK: - Movement constrains for keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        lowestConstraint.constant = keyboardFrameValue.cgRectValue.height * 0.9
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        
        lowestConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
}


//MARK: - Table View extension
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // - Implementation
        let cell = basketTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.BasketTVCell.rawValue, for: indexPath) as! BasketTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        
        
        let get = preOrderArray[cell.tag]
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        
        let name = get.productName
        let price = get.productPrice
        let category = get.productCategory
        
        // - Fill TablewView & Custom cell properties (slider.maxValue, relying on category)
        cell.fill(name: name, price: price, category: category) { image in
            if category == DatabaseManager.ProductCategoriesCases.apiece.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.hundred.rawValue)
            }
            if category == DatabaseManager.ProductCategoriesCases.bouquet.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.five.rawValue)
            }
            if category == DatabaseManager.ProductCategoriesCases.combined.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.five.rawValue)
            }
            
            
//            cell.productPriceLabel.text! = "\(price) грн"
//            cell.quantityLabel.text! = "\(Int(cell.quantitySlider.value)) шт"
//
            image.sd_setImage(with: storageRef)
        }
        
        return cell
    }
    
    // - Cell's method for delete in TableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let fetch = self.preOrderArray[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, complition) in
            NetworkManager.shared.deletePreOrderProduct(name: fetch.productName)
            self.preOrderArray.remove(at: indexPath.row)
            self.basketTableView.deleteRows(at: [indexPath], with: .automatic)
            complition(true)
        }
        action.backgroundColor = .red
        return action
    }
}


//MARK: - Custom Protocol extension
//MARK: Slider
extension BasketViewController: BasketTableViewCellDelegate {
    func sliderSelector(_ cell: BasketTableViewCell) {
        guard let name = cell.productName else {return}
        guard let price = cell.productPrice else {return}
        guard let category = cell.productCategory else {return}
        
        let sliderEquantion = Int(cell.quantitySlider.value) * price
        let sliderValue = Int(cell.quantitySlider.value)
        
        NetworkManager.shared.preOrderCorrection(name: name, price: sliderEquantion, category: category)
        
        DispatchQueue.main.async {
            NetworkManager.shared.preOrderListener { (correction) in
                self.orderBill = correction.map({$0.productPrice}).reduce(0, +)
            }
        }
        
        
        //        test.forEach { (prices) in
        //            orderBill = prices.dictionary.values.map({$0 as! Int}).reduce(0, +)
        //        }
        cell.productPriceLabel.text! = "\(sliderEquantion) грн"
        cell.quantityLabel.text! = "\(sliderValue) шт"
        
        orderPriceLabel.text = "\(orderBill as Any) грн"
    }
}
