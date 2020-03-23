//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserAboutUsViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Системные переменные
    let transition = SlideInTransition()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self as UserAboutUsViewControllerDelegate
        //MARK: Keyboard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
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
    
    //MARK: - Отправить отзыв / Переход в рабочую зону
    @IBAction func sendReviewTapped(_ sender: UIButton) {
        let name = nameTextField.text
        let review = reviewTextField.text
        
        if name == secretCode && review == secretCode2 {
            let loginWorkSpaceVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.LoginWorkSpaceVC.rawValue) as? LoginWorkSpaceViewController
            view.window?.rootViewController = loginWorkSpaceVC
            view.window?.makeKeyAndVisible()
            
            //exit anonymous user and enter for worker
            AuthenticationManager.shared.signOut()
        }else if name == "" || review == "" {
            
        }else{
            
        }
    }
    
    //MARK: - Movement constrains for keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        scrollViewBottomConstraint.constant = -keyboardFrameValue.cgRectValue.height
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: false)
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Приватные системные переменные
    weak private var delegate: UserAboutUsViewControllerDelegate?
    
    private let secretCode = "/WorkSpace"
    private let secretCode2 = "Go/"
    
    @IBOutlet weak private var scrollView: UIScrollView!
}




//MARK: - Extensions
//MARK: extensions by UIVC-bTransitioningDelegate
extension UserAboutUsViewController: UIViewControllerTransitioningDelegate {
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
extension UserAboutUsViewController: UserAboutUsViewControllerDelegate {

    //MARK: Метод перехода в другой ViewController
    func transitionByMenu(_ class: UserAboutUsViewController, _ menuType: MenuViewController.MenuType) {
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
