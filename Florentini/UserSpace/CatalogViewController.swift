//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import SDWebImage

class CatalogViewController: UIViewController {

    //MARK: - Системные переменные
    let transition = SlideInTransition()
    private var productInfoArray = [DatabaseManager.ProductInfo]()
    
    //MARK: - ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downLoadProductInfo(success: { productInfo in
            self.productInfoArray = productInfo
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    
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
        
}

    //MARK: - Collection View Extension
extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationManager.IDVC.UserCatalogCell.rawValue, for: indexPath) as! UserCatalogCollectionViewCell
        let getInfo = productInfoArray[indexPath.row]
        var images = UIImageView()
        if let url = URL(string: getInfo.productImageURL){
            DispatchQueue.main.async {
                images.sd_setImage(with: url, completed: nil)
            }
        }
        
        cell.fill(name: getInfo.productName, price: getInfo.productPrice, description: getInfo.productDescription, image: images)
        return cell
    }
    
}

//перенести из UI?
extension CatalogViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
    
    func menuOptionPicked(_ menuType: MenuType) {
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
}

