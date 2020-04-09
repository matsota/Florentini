//
//  UserHomeViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {
    
    //
    
// dispatch group for for in carodeta deletion
//
//
//
//
    
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



