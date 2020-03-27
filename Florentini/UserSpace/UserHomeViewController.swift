//
//  UserHomeViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI
import CoreData

class UserHomeViewController: UIViewController {
    
    //MARK: - Overrides
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downLoadStockOnly(success: { productInfo in
            self.productInfo = productInfo
            self.homeTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        print(AuthenticationManager.shared.currentUser?.uid as Any)
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
    
    //MARK: - Private
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    //MARK: TableView Outlet
    @IBOutlet private weak var homeTableView: UITableView!
    
    //MARK: View
    @IBOutlet private weak var noneStocksView: UIView!
    
    //MARK: Button
    @IBOutlet private weak var cartButton: UIButton!
}









//MARK: - Extention

//MARK: - by UIVC-TransitioningDelegate
extension UserHomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: - by TableView
extension UserHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.UserHomeTVCell.rawValue, for: indexPath) as! UserHomeTableViewCell,
        fetch = productInfo[indexPath.row],
        storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(fetch.productName)")
        
        cell.delegate = self
        cell.showDescription()
        cell.hideDescription()
        
        if productInfo.count == 0 {
            noneStocksView.isHidden = false
        }else{
            noneStocksView.isHidden = true
            cell.fill(name: fetch.productName, price: fetch.productPrice, description: fetch.productDescription, category: fetch.productCategory) { image in
                image.sd_setImage(with: storageRef)
            }
        }
        return cell
    }
    
}


//MARK: -

//MARK: - by User-Home-TVCellDelegate
extension UserHomeViewController: UserHomeTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: UserHomeTableViewCell) {
        guard let name = cell.productNameLabel.text, let category = cell.category, let price = Int64(cell.productPriceLabel.text!) else {return}
        
        let image = cell.cellImageView.image,
        imageData: NSData = image!.pngData()! as NSData
        
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1)
        cartCondition()
        
        UserDefaults.standard.set(imageData, forKey: name)
    }
    
}

//MARK: - Проверна на наличие предзаказа, чтобы изменить / не изменять картинку Cart
private extension UserHomeViewController {
    
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



