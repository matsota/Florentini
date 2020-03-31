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
    
    @IBOutlet weak var cartButton: UIButton!
    
    //MARK: - Overrides
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadProducts(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        cartCondition()
        
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
    @IBAction func startFiltering(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showOptionsMethod(option: sender)
    }
    
    //MARK: - Выбор категории для Фильтра
    @IBAction func endFiltering(_ sender: DesignButton) {
        selectionMethod(self, sender)
    }
    
    //MARK: - Private
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    
    //MARK: View
    @IBOutlet private weak var buttonsView: UIView!
    
    //MARK: Button Outlet
    @IBOutlet private var allFilterButtonsCollection: [DesignButton]!
    @IBOutlet private weak  var filterButton: DesignButton!
    
    //MARK: - TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
}









//MARK: - Extention:

//MARK: - by TableView
extension UserCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.UserCatalogTVCell.rawValue, for: indexPath) as! UserCatalogTableViewCell,
        fetch = productInfo[indexPath.row],
        indicator = cell.imageActivityIndicator,
        name = fetch.productName,
        price = fetch.productPrice,
        description = fetch.productDescription,
        category = fetch.productCategory,
        stock = fetch.stock,
        storagePath =  "\(NavigationCases.ProductCases.imageCollection.rawValue)/\(name)",
        storageRef = Storage.storage().reference(withPath: storagePath)
        
        cell.delegate = self
        
        indicator?.isHidden = false
        indicator?.startAnimating()
        cell.fill(name: name, price: price, description: description, category: category, stock: stock, image: { (image) in
            DispatchQueue.main.async {
                image.sd_setImage(with: storageRef, placeholderImage: nil) { (image, _, _, _) in
                    indicator?.stopAnimating()
                    indicator?.isHidden = true
                }
            }
        }) { (error) in
            indicator?.stopAnimating()
            indicator?.isHidden = true
            self.present(self.alert.alertSomeThingGoesWrong(), animated: true)
            print("ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR: \(error.localizedDescription)")
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

//MARK: - by UserCatalog-TVCell-Delegate
extension UserCatalogViewController: UserCatalogTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserCatalogTableViewCell) {
        
        let price = Int64(cell.price),
        image = cell.productImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: NSData = image?.pngData() as NSData? else {return}
        
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1, stock: stock)
        
        cartCondition()
        
        UserDefaults.standard.set(imageData, forKey: name)
    }
    
}

//MARK: - Проверна на наличие предзаказа, чтобы изменить / не изменять картинку Cart
private extension UserCatalogViewController {
    
    func cartCondition() {
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



