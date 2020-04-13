//
//  UserCatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserCatalogViewController: UIViewController {
    
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
    
    //MARK: - Decline to transition
    @IBAction func transitionDismissTapped(_ sender: UIButton) {
        slideMethod(for: self.transitionView, constraint: self.transitionViewLeftConstraint, dismissBy: self.transitionDismissButton)
    }
    //MARK: - Cart button Tapped
    @IBAction private func cartTapped(_ sender: UIButton) {
        transitionToUsersCart()
    }
    
    //MARK: - Filter option appearance
    @IBAction private func startFiltering(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showOptionsMethod(option: sender)
    }
    
    //MARK: - Category Picker
    @IBAction private func endFiltering(_ sender: DesignButton) {
        selectionMethod(self, sender)
    }
    
    //MARK: - Private
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    
    //MARK: - View
    @IBOutlet private weak var buttonsView: UIView!
    @IBOutlet private weak var transitionView: UIView!
    
    //MARK: - Button Outlet
    @IBOutlet private var allFilterButtonsCollection: [DesignButton]!
    @IBOutlet private weak var filterButton: DesignButton!
    @IBOutlet private weak var cartButton: UIButton!
    @IBOutlet private weak var transitionDismissButton: UIButton!
    
    //MARK: - TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Constraint
    @IBOutlet private weak var transitionViewLeftConstraint: NSLayoutConstraint!
    
}









//MARK: - Extention:

//MARK: - For Overrides
private extension UserCatalogViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NetworkManager.shared.downloadProducts(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        cartImageCondition()
    }
    
}


//MARK: - by TableView
extension UserCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.UserCatalogTVCell.rawValue, for: indexPath) as! UserCatalogTableViewCell,
        fetch = productInfo[indexPath.row],
        name = fetch.productName,
        price = fetch.productPrice,
        description = fetch.productDescription,
        category = fetch.productCategory,
        stock = fetch.stock
        
        cell.delegate = self
        cell.fill(name: name, price: price, description: description, category: category, stock: stock)
        
        return cell
    }
    
}

//MARK: - Filter categories appearance
private extension UserCatalogViewController {
    func showOptionsMethod(option: String) {
        selectedCategory = option
        allFilterButtonsCollection.forEach { (buttons) in
            if buttons.isHidden == true {
                UIView.animate(withDuration: 0.2) {
                    buttons.isHidden = false
                    self.filterButton.isHidden = !self.buttonsView.isHidden
                    self.buttonsView.layoutIfNeeded()
                }
            }else{
                UIView.animate(withDuration: 0.2) {
                    buttons.isHidden = true
                    self.buttonsView.layoutIfNeeded()
                }
            }
            filterButton.setTitle(option, for: .normal)
        }
    }
}

//MARK: - Category Picked
private extension UserCatalogViewController {
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let categories = NavigationCases.ProductCategoriesCases(rawValue: title) else {return}
        switch categories {
        case .apiece:
            showOptionsMethod(option: NavigationCases.ProductCategoriesCases.apiece.rawValue)
            NetworkManager.shared.downloadApieces(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .gift:
            showOptionsMethod(option: NavigationCases.ProductCategoriesCases.gift.rawValue)
            NetworkManager.shared.downloadGifts(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .bouquet:
            showOptionsMethod(option: NavigationCases.ProductCategoriesCases.bouquet.rawValue)
            NetworkManager.shared.downloadBouquets(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .stock:
            showOptionsMethod(option: NavigationCases.ProductCategoriesCases.stock.rawValue)
            NetworkManager.shared.downloadStocks(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - by Table View Cell Delegate
extension UserCatalogViewController: UserCatalogTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserCatalogTableViewCell) {
        
        let price = cell.price,
        image = cell.productImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: Data = image?.pngData() as Data? else {return}
        
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1, stock: stock, imageData: imageData, success: {
            self.cartImageCondition()
            self.present(UIAlertController.completionDoneHalfSec(title: "Товар", message: "Добавлен"), animated: true)
        }) {
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание!", message: "Произошла ошибка. Товар НЕ добавлен"), animated: true)
        }
    }
}

//MARK: - Cart image condition
private extension UserCatalogViewController {
    
    func cartImageCondition() {
        CoreDataManager.shared.fetchPreOrder { (preOrderEntity) -> (Void) in
            let preOrderAmount = preOrderEntity.count
            
            if preOrderAmount == 0 {
                let cart = UIImage(systemName: "cart")
                self.cartButton.setImage(cart, for: .normal)
            }else{
                let cartFill = UIImage(systemName: "cart.fill")
                self.cartButton.setImage(cartFill, for: .normal)
            }
        }
    }
    
}



