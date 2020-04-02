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
    func showUsersSlideInMethod() {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.MenuVC.rawValue) as? UserSlidingMenuVC else {return}
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
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.CatalogVC.rawValue) as? UserCatalogViewController
            view.window?.rootViewController = catalogVC
        case .feedback:
            let feedbackVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.FeedbackVC.rawValue) as? UserAboutUsViewController
            view.window?.rootViewController = feedbackVC
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.FAQVC.rawValue) as? UserFAQViewController
            view.window?.rootViewController = faqVC
        case .website:
            self.dismiss(animated: true, completion: nil)
        }
    }
    func transitionToUsersCart() {
        let usersCartVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.UsersCartVC.rawValue) as? UserCartViewController
        view.window?.rootViewController = usersCartVC
        view.window?.makeKeyAndVisible()
    }
    
}




//MARK: - FOR WORKERS:

//MARK: - Подготовка/Переход между Worker-ViewController'ами
extension UIViewController {
    
    //MARK: Появление Меню перехода
    func showWorkerSlideInMethod() {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.WorkMenuVC.rawValue) as? WorkerSlidingMenuVC else {return}
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
            let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.MainWorkSpaceVC.rawValue) as? EmployerOrdersViewController
            view.window?.rootViewController = ordersVC
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.WorkerCatalogVC.rawValue) as? EmployerCatalogViewController
            view.window?.rootViewController = catalogVC
        case .profile:
            let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.WorkerProfileVC.rawValue) as? EmployerProfileViewController
            view.window?.rootViewController = profileVC
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.WorkersFAQVC.rawValue) as? EmployerFAQViewController
            view.window?.rootViewController = faqVC
        case .exit:
            self.present(alert.signOut(success: {
                self.dismiss(animated: true) {
                    AuthenticationManager.shared.signOut()
                    let exitApp = self.storyboard?.instantiateInitialViewController()
                    self.view.window?.rootViewController = exitApp
                }
            }), animated: true)
        }
    }
    
    //MARK: Переход в Чат
    func transitionToWorkerChat() {
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.WorkersChatVC.rawValue) as? EmployerChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    
}


