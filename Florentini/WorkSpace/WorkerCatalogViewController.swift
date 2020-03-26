//
//  WorkerCatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

class WorkerCatalogViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data Implementation
        NetworkManager.shared.downLoadProductInfo(success: { productInfo in
            self.productInfo = productInfo
            self.catalogTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        print("certain uid: \(String(describing: AuthenticationManager.shared.currentUser?.uid))")
        print("admin uid: \(AuthenticationManager.shared.uidAdmin)")
    }
    
    //MARK: - Menu button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    
    //MARK: - Chat Transition
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    
    
    //MARK: - Private:
    
    //MARK: - Methods
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    private var productInfo = [DatabaseManager.ProductInfo]()
    
    //MARK: - TableView Outlet
    @IBOutlet weak var catalogTableView: UITableView!
    
}








//MARK: - Extention:

//MARK: - TableView Extention
extension WorkerCatalogViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.WorkerCatalogTVCell.rawValue, for: indexPath) as! WorkerCatalogTableViewCell
        cell.delegate = self
        cell.showDescription()
        cell.hideDescription()
        cell.tag = indexPath.row
        let get = productInfo[cell.tag]
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        cell.fill(name: get.productName, price: get.productPrice, category: get.productCategory, description: get.productDescription) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
    
}

//MARK: Методы TableViewCell через delegate
extension WorkerCatalogViewController: WorkerCatalogTableViewCellDelegate {
    
    //changeprice
    func editPrice(_ cell: WorkerCatalogTableViewCell){
        guard let name = cell.productNameLabel.text, let description = cell.productDescriptionLabel.text else {return}
        let category = cell.category
        if AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid {
            cell.productPriceButton.isUserInteractionEnabled = true
            
            self.present(self.alert.alertEditProductPrice(name: name, category: category, description: description, success: { newPrice in
                cell.productPriceButton.setTitle("\(newPrice) грн", for: .normal)
            }),animated: true)
        }else{
            cell.productPriceButton.isUserInteractionEnabled = false
        }
        self.catalogTableView.reloadData()
    }
    
    //deleteProduct
    func deleteProduct(name: String) {
        
        self.present(self.alert.alertDeleteProduct(name: name, success: {
            self.catalogTableView.reloadData()
        }), animated: true)
    }
    
}

//MARK: - UIVC-TransitioningDelegate
extension WorkerCatalogViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: -

