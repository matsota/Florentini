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
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        print(AuthenticationManager.shared.currentUser?.uid as Any)
        
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
    private let alert = UIAlertController()
    private var productInfo = [DatabaseManager.ProductInfo]()
    
    //MARK: TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: View
    @IBOutlet private weak var noneStocksView: UIView!
    
    //MARK: Button
    @IBOutlet private weak var cartButton: UIButton!
}









//MARK: - Extention

//MARK: - For Overrides
private extension UserHomeViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NetworkManager.shared.downloadStocks(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        cartCondition()
    }
    
    //MARK: Проверна на наличие предзаказа, чтобы изменить / не изменять картинку Cart
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.UserHomeTVCell.rawValue, for: indexPath) as! UserHomeTableViewCell,
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
        
        if productInfo.count == 0 {
            noneStocksView.isHidden = false
        }else{
            indicator?.isHidden = false
            indicator?.startAnimating()
            noneStocksView.isHidden = true
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
                self.present(self.alert.somethingWrong(), animated: true)
                print("ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR: \(error.localizedDescription)")
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
        
        let price = Int64(cell.price),
        image = cell.cellImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: NSData = image?.pngData() as NSData? else {return}
        
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1, stock: stock)
        cartCondition()
        
        UserDefaults.standard.set(imageData, forKey: name)
    }
    
}



