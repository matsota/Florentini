//
//  WorkerProfileViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseAuth

class WorkerProfileViewController: UIViewController {

    
    //MARK: - TextField Outlet
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var reNewPassword: UITextField!
    
    //MARK: - Системные переменные
    let transition = SlideInTransition()
    let alert = UIAlertController()

    //MARK: - Implementation
    var currentWorkerInfo = [DatabaseManager.WorkerInfo]()

    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //MARK: - New Product button appearance
        
            newProductButton.isHidden = false
            
        
        
    }
    //MARK: - Menu Button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        guard let workMenuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkMenuVC.rawValue) as? WorkMenuViewController else {return}
        workMenuVC.workMenuTypeTapped = { workMenuType in
    //               NavigationManager.shared.menuOptionPicked(menuType)
            self.menuOptionPicked(workMenuType)
        }
        workMenuVC.modalPresentationStyle = .overCurrentContext
        workMenuVC.transitioningDelegate = self
        present(workMenuVC, animated: true)
    }
    //menu method
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
    
    
    //MARK: - Open Chat Button
    @IBAction func chatTapped(_ sender: UIButton) {
        chatTransition()
    }
    
    //MARK: - Add New Product Button
    @IBAction func newProductTapped(_ sender: UIButton) {
    }
    
    //MARK: - Change Password Button
    @IBAction func passChangeTapped(_ sender: UIButton) {
        let newPass = newPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let reNewPass = reNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newPass != reNewPass {
            self.present(self.alert.alertClassicInfoOK(title: "Внимание", message: "Пароли не совпадают"), animated: true)
        }else if newPass == "" || reNewPass == "" {
            self.present(self.alert.alertClassicInfoOK(title: "Внимание", message: "Для смены пароля необходимо заполнить все поля"), animated: true)
        }else{
            self.present(self.alert.alertPassChange(success: {
                self.dismiss(animated: true) { self.ordersTransition()
                }
            }, password: newPass), animated: true)
        }
        
    }
    
    
    //MARK: - Information About Co-workers Method
    func workerInfoLoad() {
        guard let email = Auth.auth().currentUser?.email else {return}
        emailLabel.text = email
        emailLabel.textColor = .black
        
        NetworkManager.shared.workersInfoLoad(success: { workerInfo in
            self.currentWorkerInfo = workerInfo
            self.currentWorkerInfo.forEach { workerInfo in
                self.nameLabel.text = workerInfo.name
                self.nameLabel.textColor = .black
                self.positionLabel.text = workerInfo.position
                self.positionLabel.textColor = .black
            }
        }) { error in
            self.present(self.alert.alertSomeThingGoesWrong(), animated: true)
        }
    }
    

    //MARK: - Transition Methods
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
    
    
    //MARK: - Private Outlets
    //MARK: Button Outlet
    @IBOutlet weak private var newProductButton: UIButton!
    
    //MARK: Label Outlet
    @IBOutlet weak private var positionLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    
}


    //MARK: - Out of Class
    //MARK: - extentions
extension WorkerProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}