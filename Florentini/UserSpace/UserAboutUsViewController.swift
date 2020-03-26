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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
        print("certain uid: \(String(describing: AuthenticationManager.shared.currentUser?.uid))")
        print("admin uid: \(AuthenticationManager.shared.uidAdmin)")
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        showUsersSlideInMethod()
    }
    
    //MARK: - Отправить отзыв / Переход в рабочую зону
    @IBAction func sendReviewTapped(_ sender: UIButton) {
        reviewSent()
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
    //
    
    
    //MARK: - Implementation
    
    private let slidingMenu = SlideInTransitionMenu()
    private let secretCode = "/WorkSpace"
    private let secretCode2 = "Go/"
    private let alert = UIAlertController()
    
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

private extension UserAboutUsViewController {
    func reviewSent() {
        var name = nameTextField.text
        let review = reviewTextField.text
        
        if name == secretCode && review == secretCode2 {
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
}
