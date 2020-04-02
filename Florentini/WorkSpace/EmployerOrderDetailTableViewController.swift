//
//  OrderDetailTableViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 29.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

class EmployerOrderDetailTableViewController: UITableViewController {
    
    //MARK: - Implementation
    private var orderAddition = [DatabaseManager.OrderAddition]()
    private let alert = UIAlertController()
    
    
    @IBOutlet var orderDetailTableView: UITableView!
    
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadOrderdsAddition(success: { (orders) in
            self.orderAddition = orders
            self.orderDetailTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderAddition.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerOrdersDetailTVCell.rawValue, for: indexPath) as! EmployerOrderDetailTableViewCell,
        fetch = orderAddition[indexPath.row],
        name  = fetch.productName,
        quantity = fetch.productQuantity,
        category = fetch.productCategory,
        price = Int(fetch.productPrice),
        stock = fetch.stock,
        storagePath = "\(NavigationCases.ProductCases.imageCollection.rawValue)/\(name)",
        storageRef = Storage.storage().reference(withPath: storagePath)
        
        cell.imageActivityIndicator.isHidden = false
        cell.imageActivityIndicator.startAnimating()
        
        cell.fill(name: name, quantity: quantity, category: category, price: price, stock: stock, image: { (image) in
            DispatchQueue.main.async {
                image.sd_setImage(with: storageRef)
                cell.imageActivityIndicator.isHidden = true
                cell.imageActivityIndicator.stopAnimating()
            }
        }) { (error) in
            cell.imageActivityIndicator.isHidden = true
            cell.imageActivityIndicator.stopAnimating()
            print(error.localizedDescription)
        }
        return cell
    }
    
    //MARK: - Очистка CoreData
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        CoreDataManager.shared.deleteAllData(entity: NavigationCases.UsersInfoCases.OrderDetailPathEntity.rawValue) {
        }
    }
    
}









//MARK: - Extensions:

//MARK: - For Overrides
private extension EmployerOrderDetailTableViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
    }
    
}
