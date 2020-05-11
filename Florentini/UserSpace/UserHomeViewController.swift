//
//  UserHomeViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {

    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        print(AuthenticationManager.shared.currentUser?.uid as Any)
        
    }
    
    //MARK: - TransitionMenu button tapped
    @IBAction private func menuTapped(_ sender: UIButton) {
        slideInTransitionMenu(for: transitionView, constraint: transitionViewLeftConstraint, dismissBy: transitionDismissButton)
        print(transitionView.bounds.width, transitionViewLeftConstraint.constant, transitionView.alpha, transitionView.isUserInteractionEnabled)
    }
    
    //MARK: - Transition confirm
    @IBAction func transitionConfim(_ sender: UIButton) {
        guard let title = sender.currentTitle,
        let view = transitionView,
        let constraint = transitionViewLeftConstraint,
        let button = transitionDismissButton else {return}
        
        transitionPerform(by: title, for: view, with: constraint, dismiss: button)
    }
    
    //MARK: - Transition dismiss
    @IBAction func transitionDismiss(_ sender: UIButton) {
        slideInTransitionMenu(for: transitionView, constraint: transitionViewLeftConstraint, dismissBy: transitionDismissButton)
    }
    
    //MARK: - Cart button tapped
    @IBAction private func cartTapped(_ sender: UIButton) {
        transitionToUsersCart()
    }
    
    //MARK: - Private Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    
    //MARK: TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: View
    @IBOutlet private weak var noneStocksView: UIView!
    @IBOutlet private weak var transitionView: UIView!
    
    //MARK: Button
    @IBOutlet private weak var cartButton: UIButton!
    @IBOutlet private weak var transitionDismissButton: UIButton!
    
    //MARK: Contstraint
    @IBOutlet private weak var transitionViewLeftConstraint: NSLayoutConstraint!
    
}









//MARK: - Extention

//MARK: - For Overrides
private extension UserHomeViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        
        NetworkManager.shared.downloadStocks(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        cartImageCondition()
    }
    
    //MARK: Проверна на наличие предзаказа, чтобы изменить / не изменять картинку Cart
    func cartImageCondition() {
        CoreDataManager.shared.fetchPreOrder(success: { (preOrderEntity) -> (Void) in
            let preOrderAmount = preOrderEntity.count
            
            if preOrderAmount == 0 {
                let cart = UIImage(systemName: "cart")
                self.cartButton.setImage(cart, for: .normal)
            }else{
                let cartFill = UIImage(systemName: "cart.fill")
                self.cartButton.setImage(cartFill, for: .normal)
            }
        }) { (error) in
            self.present(UIAlertController.completionDoneTwoSec(title: "Ошибка!", message: "Что-то пошло не так"), animated: true)
            print(error.localizedDescription)
        }
    }
}

//MARK: - by TableView
extension UserHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.HomeTVCell.rawValue, for: indexPath) as! UserHomeTableViewCell,
        fetch = productInfo[indexPath.row],
        name = fetch.productName,
        price = fetch.productPrice,
        description = fetch.productDescription,
        category = fetch.productCategory,
        stock = fetch.stock
        
        cell.delegate = self
        
        if productInfo.count == 0 {
            noneStocksView.isHidden = false
        }else{
            noneStocksView.isHidden = true
            cell.fill(name: name, price: price, description: description, category: category, stock: stock)
        }
        return cell
    }
    
}

//MARK: -

//MARK: - by Table View Cell Delegate
extension UserHomeViewController: UserHomeTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserHomeTableViewCell) {
        
        let price = cell.price,
        image = cell.cellImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: Data = image?.pngData() as Data? else {return}
        
        CoreDataManager.shared.addProduct(name: name, category: category, price: price, quantity: 1, stock: stock, imageData: imageData, success: {
            self.cartImageCondition()
            self.present(UIAlertController.completionDoneHalfSec(title: "Товар", message: "Добавлен"), animated: true)
        }) {
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание!", message: "Произошла ошибка. Товар НЕ добавлен"), animated: true)
        }
    }
    
}
