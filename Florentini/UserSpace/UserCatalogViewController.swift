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
        
        prepareForTransitionDelegate = self as PrepareForUserSIMTransitionDelegate
        transitionByMenuDelegate = self as UserSlideInMenuTransitionDelegate
        
        prepareForCategorySelectionDelegate = self as PrepareForSelectionMethodDelegate
        buttonSelectionDelegate = self as SelectionByButtonCollectionDelegate
        
        NetworkManager.shared.downLoadProductInfo(success: { productInfo in
            self.productInfo = productInfo
            self.catalogTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - Появление вариантров выбора для фильтра
    @IBAction func filterTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        prepareForCategorySelectionDelegate?.showOptionsMethod(option: sender)
    }
    
    //MARK: - Выбор категории для Фильтра
    @IBAction func categorySelection(_ sender: DesignButton) {
        buttonSelectionDelegate?.selectionMethod(self, sender)
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        prepareForTransitionDelegate?.showSlideInMethod(sender)
    }
    
    //MARK: - Private
    
    //MARK: - Methods
    
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    //delegates
    private weak var prepareForCategorySelectionDelegate: PrepareForSelectionMethodDelegate?
    private weak var buttonSelectionDelegate: SelectionByButtonCollectionDelegate?
    
    private weak var prepareForTransitionDelegate: PrepareForUserSIMTransitionDelegate?
    private weak var transitionByMenuDelegate: UserSlideInMenuTransitionDelegate?
    
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

//MARK: - Подготовка к переходу между ViewController'ами
extension UserCatalogViewController: PrepareForUserSIMTransitionDelegate {
    
    func showSlideInMethod(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? UserSlidingMenuVC else {return}
        menuVC.menuTypeTapped = { menuType in
            self.transitionByMenuDelegate?.transitionMethod(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
  
}

//MARK: - Переход между ViewController'ами
extension UserCatalogViewController: UserSlideInMenuTransitionDelegate {
    
    func transitionMethod(_ class: UIViewController, _ menuType: UserSlidingMenuVC.MenuType) {
        switch menuType {
        case .home:
            let homeVC = storyboard?.instantiateInitialViewController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? UserCatalogViewController
            view.window?.rootViewController = catalogVC
            view.window?.makeKeyAndVisible()
        case .feedback:
            let feedbackVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FeedbackVC.rawValue) as? UserAboutUsViewController
            view.window?.rootViewController = feedbackVC
            view.window?.makeKeyAndVisible()
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FAQVC.rawValue) as? UserFAQViewController
            view.window?.rootViewController = faqVC
            view.window?.makeKeyAndVisible()
        case .website:
            self.dismiss(animated: true, completion: nil)
            print("website")
        }
    }
    
}

//MARK: - Появление вариантов Категорий для отфильтровывания продукции
extension UserCatalogViewController: PrepareForSelectionMethodDelegate {
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
extension UserCatalogViewController: SelectionByButtonCollectionDelegate {
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let categories = DatabaseManager.ProductCategoriesCases(rawValue: title) else {return}
        switch categories {
        case .apiece:
            prepareForCategorySelectionDelegate?.showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.apiece.rawValue)
            NetworkManager.shared.downLoadApieceOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .gift:
            prepareForCategorySelectionDelegate?.showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.gift.rawValue)
            NetworkManager.shared.downLoadGiftOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .bouquet:
            prepareForCategorySelectionDelegate?.showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.bouquet.rawValue)
            NetworkManager.shared.downLoadBouquetOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .stock:
            prepareForCategorySelectionDelegate?.showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.stock.rawValue)
            NetworkManager.shared.downLoadStockOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
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



