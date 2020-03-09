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
    
    //MARK: - Outlets
    @IBOutlet weak var catalogTableView: UITableView!
    
    //MARK: Системные переменные
    let transition = SlideInTransition()
    let alert = UIAlertController()
    
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
    
    //MARK: - Menu button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        guard let workMenuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkMenuVC.rawValue) as? WorkMenuViewController else {return}
        workMenuVC.workMenuTypeTapped = { workMenuType in
            //            NavigationManager.shared.menuOptionPicked(menuType)
            self.menuOptionPicked(workMenuType)
        }
        workMenuVC.modalPresentationStyle = .overCurrentContext
        workMenuVC.transitioningDelegate = self
        
        present(workMenuVC, animated: true)
        
    }
    
    
    //MARK: - Chat Transition
    @IBAction func chatTapped(_ sender: UIButton) {
        chatTransition()
    }
    
    
    //перенести меню в другое место.
    func menuOptionPicked(_ menuType: WorkMenuType) {
        switch menuType {
        case .orders:
            ordersTransition()
        case .catalog:
            catalogTransition()
        case .profile:
            profileTransition()
        case .faq:
            faqTransition()
        case .exit:
            print("signOut")
            self.present(self.alert.alertSignOut(success: {
                self.dismiss(animated: true) { self.exitApp()
                }
            }), animated: true)
        }
    }
    
    
    //MARK: Методы переходов
    //чат
    func chatTransition() {
        print("chat")
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersChatVC.rawValue) as? WorkersChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    //заказы
    func ordersTransition() {
        print("orders")
        let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? MainWorkSpaceViewController
        view.window?.rootViewController = ordersVC
        view.window?.makeKeyAndVisible()
    }
    //каталог
    func catalogTransition() {
        print("catalog")
        let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerCatalogVC.rawValue) as? WorkerCatalogViewController
        view.window?.rootViewController = catalogVC
        view.window?.makeKeyAndVisible()
    }
    //профиль
    func profileTransition() {
        print("profile")
        let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerProfileVC.rawValue) as? WorkerProfileViewController
        view.window?.rootViewController = profileVC
        view.window?.makeKeyAndVisible()
    }
    //часто задаваемые вопросы
    func faqTransition() {
        print("feedback")
        let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersFAQVC.rawValue) as? WorkersFAQViewController
        view.window?.rootViewController = faqVC
        view.window?.makeKeyAndVisible()
    }
    //выход
    func exitApp() {
        let exitApp = storyboard?.instantiateInitialViewController()
        view.window?.rootViewController = exitApp
        view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: - Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    
}



//MARK: - TableView Extention
extension WorkerCatalogViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.WorkerCatalogTVCell.rawValue, for: indexPath) as! WorkerCatalogTableViewCell
        
        cell.showDescription()
        
        let get = productInfo[indexPath.row]
        
        let storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        cell.fill(name: get.productName, price: get.productPrice, description: get.productDescription) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
}

//MARK: - Transition Extention
extension WorkerCatalogViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition.isPresented = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}
