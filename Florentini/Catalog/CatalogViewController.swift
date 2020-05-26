//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadProductsInfo(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func menuTapped(_ sender: UIButton) {
        
    }
    
    //MARK: - Private Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    
    //MARK: View

    
    //MARK: Button Outlet
    
    //MARK: TableView Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: Constraint
    
}









//MARK: - Extention:

//MARK: - by TableView
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.CatalogTVCell.rawValue, for: indexPath) as! CatalogTableViewCell,
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

//MARK: - Filter categories
private extension CatalogViewController {

    // - appearance
    
    
    // - selected
    
}

//MARK: - by Table View Cell Delegate
extension CatalogViewController: CatalogTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: CatalogTableViewCell) {
        
        let price = cell.price,
        image = cell.productImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: Data = image?.pngData() as Data? else {return}
        
        CoreDataManager.shared.addProduct(name: name, category: category, price: price, quantity: 1, stock: stock, imageData: imageData, success: {
            self.present(UIAlertController.completionDoneHalfSec(title: "Товар", message: "Добавлен"), animated: true)
        }) {
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание!", message: "Произошла ошибка. Товар НЕ добавлен"), animated: true)
        }
    }
}




