//
//  UIVC + Custom.swift
//  Florentini
//
//  Created by Andrew Matsota on 24.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


//MARK: - Hide Keyboard
extension UIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

//MARK: - Transition process between VC
extension UIViewController {
    
    //MARK: Hide and Show Transition Menu
    func slideInTransitionMenu(for view: UIView, constraint distance: NSLayoutConstraint, dismissBy button: UIButton) {
        let viewWidth = view.bounds.width
        button.isUserInteractionEnabled = !button.isUserInteractionEnabled
        
        if distance.constant == viewWidth {
            distance.constant = 0
            UIView.animate(withDuration: 0.5) {
                button.alpha = 0
                self.view.layoutIfNeeded()
            }
        }else{
            distance.constant = viewWidth
            UIView.animate(withDuration: 0.5) {
                button.alpha = 0.5
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: To home
    func transitionToHomeScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let homeVC = self.storyboard?.instantiateInitialViewController()
            self.view.window?.rootViewController = homeVC
        }
        success()
    }
    
    //MARK: To catalog
    func transitionToCatalogScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let catalogVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.CatalogVC.rawValue) as? UserCatalogViewController
            self.view.window?.rootViewController = catalogVC
        }
        success()
    }
    
    //MARK: To feedback
    func transitionToFeedbackScreen(success: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let feedbackVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.FeedbackVC.rawValue) as? UserAboutUsViewController
            self.view.window?.rootViewController = feedbackVC
        }
        success()
    }
    
    //MARK: To FAQ
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
    
    //MARK: To Cart
    func transitionToUsersCart() {
        let usersCartVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.UsersCartVC.rawValue) as? UserCartViewController
        view.window?.rootViewController = usersCartVC
        view.window?.makeKeyAndVisible()
    }
    
    //MARK: Transition Confirm
    func transitionPerform (by title: String, for view: UIView, with constraint: NSLayoutConstraint, dismiss button: UIButton){
        guard let cases = NavigationCases.ScreenTranstion(rawValue: title) else {return}
        let view = view,
        constraint = constraint,
        button = button
        
        switch cases {
        case .homeScreen:
            transitionToHomeScreen {
                self.slideInTransitionMenu(for: view, constraint: constraint, dismissBy: button)
            }
        case .catalogScreen:
            transitionToCatalogScreen {
                self.slideInTransitionMenu(for: view, constraint: constraint, dismissBy: button)
            }
        case .feedbackScreen:
            transitionToFeedbackScreen{
                self.slideInTransitionMenu(for: view, constraint: constraint, dismissBy: button)
            }
        case .faqScreen:
            transitionToFAQScreen{
                self.slideInTransitionMenu(for: view, constraint: constraint, dismissBy: button)
            }
        case .website:
            transitionToWebsite{
                self.slideInTransitionMenu(for: view, constraint: constraint, dismissBy: button)
            }
        }
    }
}


