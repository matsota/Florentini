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
    
    //MARK: Hide and Show Transition Menu
    func slideMethod(for view: UIView, constraint distance: NSLayoutConstraint, dismissBy button: UIButton) {
        let viewWidth = view.bounds.width
        button.isUserInteractionEnabled = !button.isUserInteractionEnabled
        
        if distance.constant == -viewWidth {
            distance.constant = 0
            UIView.animate(withDuration: 0.3) {
                button.alpha = 0.5
                self.view.layoutIfNeeded()
            }
        }else{
            distance.constant = -viewWidth
            UIView.animate(withDuration: 0.4) {
                button.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func transitionToHomeScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let homeVC = self.storyboard?.instantiateInitialViewController()
            self.view.window?.rootViewController = homeVC
        }
        success()
    }
    func transitionToCatalogScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let catalogVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.CatalogVC.rawValue) as? UserCatalogViewController
            self.view.window?.rootViewController = catalogVC
        }
        success()
    }
    func transitionToFeedbackScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.FeedbackVC.rawValue) as? UserAboutUsViewController
            self.view.window?.rootViewController = feedbackVC
        }
        success()
    }
    func transitionToFAQScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let faqVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.FAQVC.rawValue) as? UserFAQViewController
            self.view.window?.rootViewController = faqVC
        }
        success()
    }
    func transitionToWebsite(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            UIApplication.shared.open(URL(string: "https://florentini.space")! as URL, options: [:], completionHandler: nil)
        }
        success()
    }
    
    
    func transitionToUsersCart() {
        let usersCartVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.UsersCartVC.rawValue) as? UserCartViewController
        view.window?.rootViewController = usersCartVC
        view.window?.makeKeyAndVisible()
    }
    
    //MARK: Выбор перехода
    func transitionPerform (by title: String, for view: UIView, with constraint: NSLayoutConstraint, dismiss button: UIButton){
        guard let cases = NavigationCases.TranstionCases(rawValue: title) else {return}
        let view = view,
        constraint = constraint,
        button = button
        
        switch cases {
        case .homeScreen:
            transitionToHomeScreen {
                self.slideMethod(for: view, constraint: constraint, dismissBy: button)
            }
        case .catalogScreen:
            transitionToCatalogScreen {
                self.slideMethod(for: view, constraint: constraint, dismissBy: button)
            }
        case .feedbackScreen:
            transitionToFeedbackScreen{
                self.slideMethod(for: view, constraint: constraint, dismissBy: button)
            }
        case .faqScreen:
            transitionToFAQScreen{
                self.slideMethod(for: view, constraint: constraint, dismissBy: button)
            }
        case .website:
            transitionToWebsite{
                self.slideMethod(for: view, constraint: constraint, dismissBy: button)
            }
        }
    }
}




//MARK: - FOR WORKERS:

//MARK: - Подготовка/Переход между Worker-ViewController'ами
extension UIViewController {
    
    //MARK: Появление Меню перехода
    func showWorkerSlideInMethod() {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerMenuVC.rawValue) as? EmployerSlidingMenuVC else {return}
        menuVC.employerMenuTypeTapped = { workMenuType in
            self.employerTransitionBySlidingVC(self, workMenuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        present(menuVC, animated: true)
    }
    
    //MARK: Выбор перехода
    func employerTransitionBySlidingVC(_ class: UIViewController, _ menuType: EmployerSlidingMenuVC.EmployerMenuType) {
        switch menuType {
        case .orders:
            let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerOrdersVC.rawValue) as? EmployerOrdersViewController
            view.window?.rootViewController = ordersVC
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerCatalogVC.rawValue) as? EmployerCatalogViewController
            view.window?.rootViewController = catalogVC
        case .profile:
            let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerProfileVC.rawValue) as? EmployerProfileViewController
            view.window?.rootViewController = profileVC
        case .faq:
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerFAQVC.rawValue) as? EmployerFAQViewController
            view.window?.rootViewController = faqVC
        case .exit:
            self.present(UIAlertController.signOut(success: {
                self.dismiss(animated: true) {
                    let exitApp = self.storyboard?.instantiateInitialViewController()
                    self.view.window?.rootViewController = exitApp
                }
            }), animated: true)
        }
    }
    
    //MARK: Переход в Чат
    func transitionToEmployerChat() {
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerChatVC.rawValue) as? EmployerChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    
}


