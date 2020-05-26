//
//  HomeViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // - fill tableView
         NetworkManager.shared.downloadStocks(success: { productInfo in
             self.productInfo = productInfo.shuffled()
             self.tableView.reloadData()
         }) { error in
             print(error.localizedDescription)
         }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Private Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    
    //MARK: TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: View
    @IBOutlet private weak var noneStocksView: UIView!
    
}









//MARK: - Extention

//MARK: - by TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.HomeTVCell.rawValue, for: indexPath) as! HomeTableViewCell,
        fetch = productInfo[indexPath.row],
        name = fetch.productName,
        price = fetch.productPrice,
        description = fetch.productDescription,
        category = fetch.productCategory,
        stock = fetch.stock
        
        cell.delegate = self
        cell.imageActivityIndicator.startAnimating()
        
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
extension HomeViewController: HomeTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: HomeTableViewCell) {
        
        let price = cell.price,
        image = cell.cellImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: Data = image?.pngData() as Data? else {return}
        
        CoreDataManager.shared.addProduct(name: name, category: category, price: price, quantity: 1, stock: stock, imageData: imageData, success: {
            self.present(UIAlertController.completionDoneHalfSec(title: "Товар", message: "Добавлен"), animated: true)
            guard let cartItem = self.tabBarController?.tabBar.items?[0] else {return}
            CoreDataManager.shared.cartIsEmpty(bar: cartItem)
        }) {
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание!", message: "Произошла ошибка. Товар НЕ добавлен"), animated: true)
        }
    }
    
}
