//
//  UserHomeViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


class UserHomeViewController: UIViewController {
    
    //MARK: - Overrides
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForTransitionDelegate = self as PrepareForUserSIMTransitionDelegate
        transitionByMenuDelegate = self as UserSlideInMenuTransitionDelegate
        
        AuthenticationManager.shared.signInAnonymously()
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        prepareForTransitionDelegate?.showSlideInMethod(sender)
    }
    
    //MARK: - Private
    
    //MARK: - Methods
    
    
    //MARK: - Implementation
    
    private let slidingMenu = SlideInTransitionMenu()
    //delegates
    private weak var prepareForTransitionDelegate: PrepareForUserSIMTransitionDelegate?
    private weak var transitionByMenuDelegate: UserSlideInMenuTransitionDelegate?

    
}









//MARK: - Extention HomeViewControllerr
//MARK: extention by UIVC-TransitioningDelegate
extension UserHomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: - Подготовка к переходу между ViewController'ами
extension UserHomeViewController: PrepareForUserSIMTransitionDelegate {
    
    func showSlideInMethod(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? UserSlidingMenuVC else {return}
        menuVC.menuTypeTapped = { menuType in
            self.transitionByMenuDelegate?.transitionMethod(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
  
}

//MARK: - Переход между ViewController'ами
extension UserHomeViewController: UserSlideInMenuTransitionDelegate {
    
    func transitionMethod(_ class: UIViewController, _ menuType: UserSlidingMenuVC.MenuType) {
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






