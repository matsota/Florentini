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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getPreOrder(success: { (preOrder) in
            self.preOrderArray = preOrder
            self.basketTableView.reloadData()
        }) { (error) in
            print("error: \(error.localizedDescription)")
        }
        
//        NetworkManager.shared.updatePreOrder(name: "21"){ changed in
//            self.preOrderArray.remove(at: indexPath.row)
//            DispatchQueue.main.async {
//                self.basketTableView.reloadData()
//            }
//        }
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


extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = basketTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.BasketTVCell.rawValue, for: indexPath) as! BasketTableViewCell
        
        let get = preOrderArray[indexPath.row]
        
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        
        cell.fill(name: get.productName, price: get.productPrice) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
    
}

extension BasketViewController: BasketTableViewCellDelegate {
    func deleteFromBasketTableViewCell(_ cell: BasketTableViewCell) {
        NetworkManager.shared.deleteProduct(name: cell.productNameLabel.text!)
    }
}
