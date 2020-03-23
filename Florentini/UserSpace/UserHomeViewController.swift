//
//  ViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


class UserHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self as UserHomeViewControllerDelegate
        
        //user is anonymous
        AuthenticationManager.shared.signInAnonymously()
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? MenuViewController else {return}
        menuVC.menuTypeTapped = { menuType in
            self.delegate?.transitionByMenu(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
    
    
    //MARK: - Нажатие кнопки Корзины
    @IBAction func basketTapped(_ sender: UIButton) {
        let basketVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.BasketVC.rawValue) as? UserBasketViewController
        view.window?.rootViewController = basketVC
        view.window?.makeKeyAndVisible()
    }
    
    //MARK: - Private
    //MARK:Implementation
    weak private var delegate: UserHomeViewControllerDelegate?
    private let transition = SlideInTransition()
    
    //MARK: Methods
//    private func transitionForward(_ idPath: String, success: @escaping(UIViewController) -> Void) {
//        guard var vc = storyboard?.instantiateViewController(withIdentifier: idPath) else {return}
//           view.window?.rootViewController = vc
//           view.window?.makeKeyAndVisible()
//        success(vc)
//       }
}









//MARK: - Extention HomeViewControllerr
//MARK: extention by UIVC-TransitioningDelegate
extension UserHomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}

//MARK: extention by UserHome-VC-Delegate
extension UserHomeViewController: UserHomeViewControllerDelegate {
    
    //MARK: Метод перехода в другой ViewController
    func transitionByMenu(_ class: UserHomeViewController, _ menuType: MenuViewController.MenuType) {
        switch menuType {
        case .home:
            let homeVC = storyboard?.instantiateInitialViewController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? CatalogViewController
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






