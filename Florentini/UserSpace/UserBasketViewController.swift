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


class UserBasketViewController: UIViewController {

    //MARK: - Overrides
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectingFeedbackDelegate = self as SelectionByButtonCollectionDelegate
        prepareForFeedbackSelectionDelegate = self as PrepareForSelectionMethodDelegate
        
        CoreDataManager.shared.fetchPreOrder { (preOrderEntity) -> (Void) in
            self.preOrder = preOrderEntity
            self.basketTableView.reloadData()
            print(self.preOrder)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Нажатие кнопки Обратной связи
    @IBAction func feedbackTypeSelectorTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        prepareForFeedbackSelectionDelegate?.showOptionsMethod(option: sender)
    }

    @IBAction func feedbackTypeTapped(_ sender: DesignButton) {
        selectingFeedbackDelegate?.selectionMethod(self, sender)
    }
    
    //MARK: - Подтвреждение заказа
    @IBAction func confirmTapped(_ sender: UIButton) {
    }
    
    
    //MARK: - Private:
    
    //MARK: - Methods
    //MARK: Смещение constrains при появлении клавиатуры
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
    
    
    //MARK: - Implementation
    
    private var selectedFeedbackType: String?
    private var orderBill = Int64()
    private var preOrder = [PreOrderEntity]()
    //delegates
    private weak var selectingFeedbackDelegate: SelectionByButtonCollectionDelegate?
    private weak var prepareForFeedbackSelectionDelegate: PrepareForSelectionMethodDelegate?
    
    //MARK: Views Outlets
    @IBOutlet private weak var buttonsView: UIView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    //MARK: TableView Outlets
    @IBOutlet private weak var basketTableView: UITableView!
    
    //MARK: TextFields Outlets
    @IBOutlet private weak var clientNameTextField: UITextField!
    @IBOutlet private weak var clientPhoeNumberTextField: UITextField!
    @IBOutlet private weak var clientAdressTextField: UITextField!
    @IBOutlet private weak var clientDescriptionTextField: UITextField!
    @IBOutlet private weak var orderPriceLabel: UILabel!
    
    //MARK: Buttons Outlets
    @IBOutlet private var feedbackTypeBttnsCellection: [UIButton]!
    @IBOutlet private weak var feebackTypeSelectorButton: UIButton!

    
    //MARK: Constrains Outlets
    @IBOutlet private weak var lowestConstraint: NSLayoutConstraint!

}


//MARK: - Table View extension
extension UserBasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // - Implementation
        let cell = basketTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.BasketTVCell.rawValue, for: indexPath) as! UserBasketTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        let fetch = preOrder[cell.tag]
        //from coreData
        let name = fetch.value(forKey: DatabaseManager.ProductCases.productName.rawValue) as! String
        let category = fetch.value(forKey: DatabaseManager.ProductCases.productCategory.rawValue) as! String
        let price = fetch.value(forKey: DatabaseManager.ProductCases.productPrice.rawValue) as! Int64
        let sliderValue = fetch.value(forKey: DatabaseManager.ProductCases.productQuantity.rawValue) as! Int64
        let imageData = UserDefaults.standard.object(forKey: name) as! NSData
        
        //maxValue correction of sliders in each cell
        if category == DatabaseManager.ProductCategoriesCases.apiece.rawValue {
            cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.hundred.rawValue)
        }
        if category == DatabaseManager.ProductCategoriesCases.bouquet.rawValue {
            cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.five.rawValue)
        }
        //
        cell.fill (name: name , price: price, slider: sliderValue, imageData: imageData)
        
        return cell
    }
    
    // - Cell's method for delete in TableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, complition) in
            CoreDataManager.shared.deleteFromCart(deleteWhere: self.preOrder, at: indexPath)
            self.preOrder.remove(at: indexPath.row)
            self.basketTableView.deleteRows(at: [indexPath], with: .automatic)
            complition(true)
        }
        action.backgroundColor = .red
        return action
    }
    
}


//MARK: - Custom Protocol extension

//MARK: Прокрутка слайдера для выбора количества + Метод (Изменение конечной стоимости продукта в зависимости от выбранного количества)
extension UserBasketViewController: UserBasketTableViewCellDelegate {
    
    func sliderValue(_ cell: UserBasketTableViewCell) {
        guard let price = cell.productPrice else {return}
        guard let name = cell.productName else {return}
        guard let fetch = try! PersistenceService.context.fetch(PreOrderEntity.fetchRequest()) as? [PreOrderEntity] else {return}
        
        let sliderEquantion = Int64(cell.quantitySlider.value) * price
        let sliderValue = Int64(cell.quantitySlider.value)
        
        cell.productPriceLabel.text! = "\(sliderEquantion) грн"
        cell.quantityLabel.text! = "\(sliderValue) шт"
        
        CoreDataManager.shared.updateCart(name: name, quantity: sliderValue)
        self.orderBill = fetch.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
        self.orderPriceLabel.text = "\(self.orderBill) грн"
    }
    
}

//MARK: Появление вариантов обратной связи
extension UserBasketViewController: SelectionByButtonCollectionDelegate {
    
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let feedbackType = DatabaseManager.FeedbackTypesCases(rawValue: title) else {return}
        switch feedbackType {
        case .cellphone:
            prepareForFeedbackSelectionDelegate?.showOptionsMethod(option: DatabaseManager.FeedbackTypesCases.cellphone.rawValue)
        case .viber:
            prepareForFeedbackSelectionDelegate?.showOptionsMethod(option: DatabaseManager.FeedbackTypesCases.viber.rawValue)
        case .telegram:
            prepareForFeedbackSelectionDelegate?.showOptionsMethod(option: DatabaseManager.FeedbackTypesCases.telegram.rawValue)
        }
    }
    
}

//MARK: Выбор способа обратной связи
extension UserBasketViewController: PrepareForSelectionMethodDelegate {
    
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


