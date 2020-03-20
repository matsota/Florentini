//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CatalogViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var catalogTableView: UITableView!
    
    //MARK: - Системные переменные
    let transition = SlideInTransition()
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
        
    }
    
    
    //MARK: - Menu НАДО ПЕРЕНЕСТИ ЕГО ИЗ UI
    @IBAction func menuTapped(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? MenuViewController else {return}
        menuVC.menuTypeTapped = { menuType in
            //            NavigationManager.shared.menuOptionPicked(menuType)
            self.menuOptionPicked(menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
    
    func menuOptionPicked(_ menuType: MenuViewController.MenuType) {
        switch menuType {
        case .home:
            print("website")
            let homeVC = storyboard?.instantiateInitialViewController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            print("catalog")
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? CatalogViewController
            view.window?.rootViewController = catalogVC
            view.window?.makeKeyAndVisible()
        case .feedback:
            print("feedback")
            let feedbackVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FeedbackVC.rawValue) as? AboutUsViewController
            view.window?.rootViewController = feedbackVC
            view.window?.makeKeyAndVisible()
        case .faq:
            print("feedback")
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FAQVC.rawValue) as? FAQViewController
            view.window?.rootViewController = faqVC
            view.window?.makeKeyAndVisible()
        case .website:
            print("website")
        }
    }
    
    //MARK: - Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    
}


//MARK: - TableView Extention
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.UserCatalogTVCell.rawValue, for: indexPath) as! UserCatalogTableViewCell
        cell.delegate = self
        cell.showDescription()
        
        let get = productInfo[indexPath.row]
        
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        cell.fill(name: get.productName, price: get.productPrice, description: get.productDescription, category: get.productCategory) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
}


//MARK: - Menu Extention
extension CatalogViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}

extension CatalogViewController: UserCatalogTableViewCellDelegate {
    func addToCart(_ cell: UserCatalogTableViewCell) {
        guard let name = cell.productNameLabel.text, let category = cell.category, let price = Int64(cell.productPriceLabel.text!) else {return}
        CoreDataManager.shared.saveForCart(name: name, category: category, price: price, quantity: 1)
        let image = cell.productImageView.image
        let imageData: NSData = image!.pngData()! as NSData
        UserDefaults.standard.set(imageData, forKey: name)
    }
}

