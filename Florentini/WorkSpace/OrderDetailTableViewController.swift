//
//  OrderDetailTableViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 29.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

class OrderDetailTableViewController: UITableViewController {
    
    //MARK: - Implementation
    var orderAddition = [DatabaseManager.OrderAddition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadOrderdsAddition(success: { (orders) in
            self.orderAddition = orders
            print(orders)
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        NetworkManager.shared.downloadMainOrderInfo(success: { (info) in
            print(info)
        }) { (err) in
            print(err.localizedDescription)
        }
        
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderAddition.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerOrdersDetailTVCell.rawValue, for: indexPath) as! OrderDetailTableViewCell,
        fetch = orderAddition[indexPath.row],
        storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(fetch.productName)")
        
        
        
        cell.fill(name: fetch.productName, quantity: Int(fetch.productQuantity), category: fetch.productCategory, price: Int(fetch.productPrice), stock: fetch.stock) { image in
            image.sd_setImage(with: storageRef)
        }
        
        return cell
    }
    
    
}
