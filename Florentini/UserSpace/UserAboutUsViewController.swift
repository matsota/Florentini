//
//  UserAboutUsViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserAboutUsViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForTransitionDelegate = self as PrepareForUserSIMTransitionDelegate
        transitionByMenuDelegate = self as UserSlideInMenuTransitionDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        prepareForTransitionDelegate?.showSlideInMethod(sender)
    }
    
    //MARK: - Отправить отзыв / Переход в рабочую зону
    @IBAction func sendReviewTapped(_ sender: UIButton) {
        var name = nameTextField.text
        let review = reviewTextField.text
        
        if name == secretCode && review == secretCode2 {
            //exit anonymous user and enter for worker
            AuthenticationManager.shared.signOut()
            let loginWorkSpaceVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.LoginWorkSpaceVC.rawValue) as? LoginWorkSpaceViewController
            view.window?.rootViewController = loginWorkSpaceVC
            view.window?.makeKeyAndVisible()
        }else if review == "" {
            if name == "" {name = "anonymous"}
            self.present(self.alert.alertClassicInfoOK(title: "Эттеншн!", message: "Вы не ввели информацию, которой бы Вы хотели поделиться с нами"), animated: true)
        }else{
            NetworkManager.shared.sendReview(name: name!, content: review!)
        }
    }
    
    
    //MARK: - Private:
    
    //MARK: - Methods
    
    //MARK: Movement constrains for keyboard
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
    
    
    //MARK: - Implementation
    
    private let slidingMenu = SlideInTransitionMenu()
    private let secretCode = "/WorkSpace"
    private let secretCode2 = "Go/"
    private let alert = UIAlertController()
    //delegates
    private weak var prepareForTransitionDelegate: PrepareForUserSIMTransitionDelegate?
    private weak var transitionByMenuDelegate: UserSlideInMenuTransitionDelegate?
    
    //MARK: ScrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var reviewTextField: UITextField!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
}









//MARK: - Extensions
//MARK: - Появление SlidingMenu
extension UserAboutUsViewController: UIViewControllerTransitioningDelegate {
    
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
extension UserAboutUsViewController: PrepareForUserSIMTransitionDelegate {
    
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
extension UserAboutUsViewController: UserSlideInMenuTransitionDelegate {
    
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
