//
//  BasketViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

class BasketViewController: UIViewController {
    
    //MARK: - Overrides
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getPreOrder(success: { (preOrder) in
            self.preOrderArray = preOrder
            self.basketTableView.reloadData()
        }) { (error) in
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: - Подтвреждение заказа
    @IBAction func confirmTapped(_ sender: UIButton) {
    }
    
    //MARK: - Private Outlets
    @IBOutlet weak private var basketTableView: UITableView!
    @IBOutlet weak private var orderPriceLabel: UILabel!
    
    //MARK: - Приватные переменные
    var preOrderArray = [DatabaseManager.PreOrder]()
}


//MARK: - Table View extension
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
// - Implementation
        let cell = basketTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.BasketTVCell.rawValue, for: indexPath) as! BasketTableViewCell
        cell.delegate = self
        cell.tag = indexPath.row
        
        let get = preOrderArray[cell.tag]
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        
        let name = get.productName
        let price = get.productPrice
        let category = get.productCategory
    
        
// - Fill TablewView & Custom cell properties (slider.maxValue, relying on category)
        cell.fill(name: name, price: price, category: category) { image in
            if category == DatabaseManager.ProductCategoriesCases.apiece.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.hundred.rawValue)
            }
            if category == DatabaseManager.ProductCategoriesCases.bouquet.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.five.rawValue)
            }
            if category == DatabaseManager.ProductCategoriesCases.combined.rawValue {
                cell.quantitySlider.maximumValue = Float(DatabaseManager.MaxQuantityByCategoriesCases.five.rawValue)
            }
            
            cell.productPriceLabel.text! = "\(price) грн"
            cell.quantityLabel.text! = "\(Int(cell.quantitySlider.value)) шт"
            image.sd_setImage(with: storageRef)
        }
        
        return cell
    }
    
// - Cell's method for delete in TableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let fetch = self.preOrderArray[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, complition) in
            NetworkManager.shared.deletePreOrderProduct(name: fetch.productName)
            self.preOrderArray.remove(at: indexPath.row)
            self.basketTableView.deleteRows(at: [indexPath], with: .automatic)
            complition(true)
        }
        action.backgroundColor = .red
        return action
    }
    
}


//MARK: - Custom Protocol extension
//MARK: Slider
extension BasketViewController: BasketTableViewCellDelegate {
    func sliderSelector(_ cell: BasketTableViewCell) {
        guard let price = cell.productPrice else {return}
        cell.productPriceLabel.text! = "\(Int(cell.quantitySlider.value) * price) грн"
        cell.quantityLabel.text! = "\(Int(cell.quantitySlider.value)) шт"
    }
}
