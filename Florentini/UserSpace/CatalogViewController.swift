//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CatalogViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var catalogTableView: UITableView!
    
    //MARK: - Системные переменные
    let transition = SlideInTransition()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self as UserCatalogViewControllerDelegate
        
        //data Implementation
        NetworkManager.shared.downLoadProductInfo(success: { productInfo in
            self.productInfo = productInfo
            self.catalogTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - Методы фильтрации Отображаемых картинок
    @IBAction func filterTapped(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        delegate?.hideAndShowCategories(option: sender)
    }
    
    @IBAction func categorySelected(_ sender: DesignButton) {
        delegate?.filtrationProductsByCategory(self, sender)
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? MenuViewController else {return}
        menuVC.menuTypeTapped = { menuType in
            self.delegate?.transitionByMenu(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
    
    //MARK: - Private
    //MARK: Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    weak private var delegate: UserCatalogViewControllerDelegate?
    
    //MARK: View
    @IBOutlet weak private var buttonsView: UIView!
    
    //MARK: Button Outlets
    @IBOutlet private var allFilterButtonsCollection: [DesignButton]!
    @IBOutlet weak private var filterButton: DesignButton!
}









//MARK: - extention by TableView
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource{
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

//MARK: - extention by  UIVC-TransitioningDelegate
extension CatalogViewController: UIViewControllerTransitioningDelegate {
    //MARK: For slider menu
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}

//MARK: - extention by UserCatalog-TVC-Delegate
extension CatalogViewController: UserCatalogTableViewCellDelegate {
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserCatalogTableViewCell) {
        guard let name = cell.productNameLabel.text, let category = cell.category, let price = Int64(cell.productPriceLabel.text!) else {return}
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1)
        let image = cell.productImageView.image
        let imageData: NSData = image!.pngData()! as NSData
        UserDefaults.standard.set(imageData, forKey: name)
    }
}


//MARK: - extention by Catalog-VC-Delegate
extension CatalogViewController: UserCatalogViewControllerDelegate {
    //MARK: Метод появление/сокрытия Категорий для дальнейшей фильтрации продукции
    func hideAndShowCategories(option: String) {
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
    
    //MARK: Метод фильтрации продукции по категориям
    func filtrationProductsByCategory(_ class: CatalogViewController, _ sender: DesignButton) {
        guard let title = sender.currentTitle, let categories = DatabaseManager.ProductCategoriesCases(rawValue: title) else {return}
        switch categories {
        case .apiece:
            hideAndShowCategories(option: DatabaseManager.ProductCategoriesCases.apiece.rawValue)
            NetworkManager.shared.downLoadApieceOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .gift:
            hideAndShowCategories(option: DatabaseManager.ProductCategoriesCases.gift.rawValue)
            NetworkManager.shared.downLoadGiftOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .bouquet:
            hideAndShowCategories(option: DatabaseManager.ProductCategoriesCases.bouquet.rawValue)
            NetworkManager.shared.downLoadBouquetOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .stock:
            hideAndShowCategories(option: DatabaseManager.ProductCategoriesCases.stock.rawValue)
            NetworkManager.shared.downLoadStockOnly(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.catalogTableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Метод перехода в другой ViewController
    func transitionByMenu(_ class: CatalogViewController, _ menuType: MenuViewController.MenuType) {
        switch menuType {
        case .home:
            let homeVC = storyboard?.instantiateInitialViewController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? CatalogViewController
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
            print("website")
        }
    }
    
}



