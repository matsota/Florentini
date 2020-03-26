//
//  UserCatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class UserCatalogViewController: UIViewController {
    
    //MARK: - Overrides
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downLoadProductInfo(success: { productInfo in
            self.productInfo = productInfo
            self.catalogTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        print("certain uid: \(String(describing: AuthenticationManager.shared.currentUser?.uid))")
        print("admin uid: \(AuthenticationManager.shared.uidAdmin)")
        
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        showUsersSlideInMethod()
    }
    
    //MARK: - Нажатие кнопки Cart
    @IBAction func cartTapped(_ sender: UIButton) {
        transitionToUsersCart()
    }
    
    //MARK: - Появление вариантров выбора для фильтра
    @IBAction func filterTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showOptionsMethod(option: sender)
    }
    
    //MARK: - Выбор категории для Фильтра
    @IBAction func categorySelection(_ sender: DesignButton) {
        selectionMethod(self, sender)
    }

    //MARK: - Private
    
    //MARK: - Methods
    
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    
    //MARK: View
    @IBOutlet private weak var buttonsView: UIView!
    
    //MARK: Button Outlet
    @IBOutlet private var allFilterButtonsCollection: [DesignButton]!
    @IBOutlet private weak  var filterButton: DesignButton!
    
    //MARK: - TableView Outlet
    @IBOutlet private weak var catalogTableView: UITableView!
    
}









//MARK: - Extention:

//MARK: - by TableView
extension UserCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.UserCatalogTVCell.rawValue, for: indexPath) as! UserCatalogTableViewCell
        cell.delegate = self
        cell.showDescription()
        cell.hideDescription()
        
        let get = productInfo[indexPath.row]
        
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        cell.fill(name: get.productName, price: get.productPrice, description: get.productDescription, category: get.productCategory) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
    
}

//MARK: -

//MARK: - Появление SlidingMenu
extension UserCatalogViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: - Появление вариантов Категорий для отфильтровывания продукции
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

//MARK: - Метод фильтрации продукции по категориям
private extension UserCatalogViewController {
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let categories = DatabaseManager.ProductCategoriesCases(rawValue: title) else {return}
        switch categories {
        case .apiece:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.apiece.rawValue)
            NetworkManager.shared.downLoadApieceOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .gift:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.gift.rawValue)
            NetworkManager.shared.downLoadGiftOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .bouquet:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.bouquet.rawValue)
            NetworkManager.shared.downLoadBouquetOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .stock:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.stock.rawValue)
            NetworkManager.shared.downLoadStockOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .none:
            break
        }
    }
}

//MARK: - by UserCatalog-TVCell-Delegate
extension UserCatalogViewController: UserCatalogTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserCatalogTableViewCell) {
        guard let name = cell.productNameLabel.text, let category = cell.category, let price = Int64(cell.productPriceLabel.text!) else {return}
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1)
        let image = cell.productImageView.image
        let imageData: NSData = image!.pngData()! as NSData
        UserDefaults.standard.set(imageData, forKey: name)
    }

}



