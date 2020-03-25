//
//  UIVC + Custom.swift
//  Florentini
//
//  Created by Andrew Matsota on 24.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


//MARK: - COMMON:

//MARK: - Hide Keyboard
extension UIViewController {
    
    //call in viewdidload
    @objc func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}




//MARK: - FOR USERS:

//MARK: - Подготовка/Переход между User-ViewController'ами
extension UIViewController {
    
    //MARK: Появление Меню перехода
    func showUsersSlideInMethod(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? UserSlidingMenuVC else {return}
        menuVC.menuTypeTapped = { menuType in
            self.userTransitionBySlidingVC(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        present(menuVC, animated: true)
    }

    //MARK: Выбор перехода
    func userTransitionBySlidingVC(_ class: UIViewController, _ menuType: UserSlidingMenuVC.MenuType) {
        switch menuType {
        case .home:
            let homeVC = storyboard?.instantiateInitialViewController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? UserCatalogViewController
            view.window?.rootViewController = catalogVC
            view.window?.makeKeyAndVisible()
        case .feedback:
            let feedbackVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FeedbackVC.rawValue) as? UserAboutUsViewController
            view.window?.rootViewController = feedbackVC
            view.window?.makeKeyAndVisible()
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FAQVC.rawValue) as? UserFAQViewController
            view.window?.rootViewController = faqVC
            view.window?.makeKeyAndVisible()
        case .website:
            self.dismiss(animated: true, completion: nil)
            print("website")
        }
    }
    
}




//MARK: - FOR WORKERS:

//MARK: - Подготовка/Переход между Worker-ViewController'ами
extension UIViewController {
    
    //MARK: Появление Меню перехода
    func showWorkerSlideInMethod(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkMenuVC.rawValue) as? WorkerSlidingMenuVC else {return}
        menuVC.workMenuTypeTapped = { workMenuType in
            self.workerTransitionBySlidingVC(self, workMenuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        present(menuVC, animated: true)
    }
    
    //MARK: Выбор перехода
    func workerTransitionBySlidingVC(_ class: UIViewController, _ menuType: WorkerSlidingMenuVC.WorkMenuType) {
        let alert = UIAlertController()
        switch menuType {
        case .orders:
            let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? WorkerMainSpaceViewController
            view.window?.rootViewController = ordersVC
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerCatalogVC.rawValue) as? WorkerCatalogViewController
            view.window?.rootViewController = catalogVC
        case .profile:
            let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerProfileVC.rawValue) as? WorkerProfileViewController
            view.window?.rootViewController = profileVC
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersFAQVC.rawValue) as? WorkerFAQViewController
            view.window?.rootViewController = faqVC
        case .exit:
            print("signOut")
            self.present(alert.alertSignOut(success: {
                self.dismiss(animated: true) {
                    let exitApp = self.storyboard?.instantiateInitialViewController()
                    self.view.window?.rootViewController = exitApp
                }
            }), animated: true)
        }
    }
    
    //MARK: Переход в Чат
    func transitionToWorkerChat(_ sender: UIButton) {
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersChatVC.rawValue) as? WorkerChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    
}


