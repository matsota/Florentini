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
    
    //ETO
        var price = Int()
}


//MARK: - Table View extension
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.BasketTVCell.rawValue, for: indexPath) as! BasketTableViewCell
        //init delegat
        cell.delegate = self
        
        let get = preOrderArray[indexPath.row]
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        
        cell.fill(name: get.productName, price: get.productPrice) { image in
            image.sd_setImage(with: storageRef)
        }
        
        
        //ETO
        for _ in 0...preOrderArray.count {
            price += get.productPrice
            print(get.productPrice)
//            orderPriceLabel.text! = "\(price)"
        }
        orderPriceLabel.text! = "\(price)"
        
//        //row init for every position
//        cell.tag = indexPath.row
        return cell
    }
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
extension BasketViewController: BasketTableViewCellDelegate {
    func sliderSelector(_ cell: BasketTableViewCell) {
        cell.quantityLabel.text! = "\(Int(cell.quantitySlider.value)) шт."
        
        guard let price = Int(cell.productPriceLabel.text!) else {return}
        cell.productPriceLabel.text = "\(Int(cell.quantitySlider.value) * price) грн"
        basketTableView.reloadData()
    }
    ///Не обновляет значение cell.productPriceLabel.text, когда слайдер двигаю
}
