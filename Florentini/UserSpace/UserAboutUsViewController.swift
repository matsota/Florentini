//
//  UserAboutUsViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserAboutUsViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        
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
    
    //MARK: - Implementation
    
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    //MARK: ScrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: Outlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
}









//MARK: - Extensions

//MARK: - For Overrides
private extension UserAboutUsViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
        setTextViewPlaceholder()
        

    }
    
}

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
        
        let review = reviewTextView.text,
        secretCode = "/WorkSpace",
        secretCode2 = "Go/"
        
        if name == secretCode && review == secretCode2 {
            let loginWorkSpaceVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.LoginWorkSpaceVC.rawValue) as? LoginWorkSpaceViewController
            view.window?.rootViewController = loginWorkSpaceVC
            view.window?.makeKeyAndVisible()
        }else if review == "" {
            self.present(self.alert.classic(title: "Эттеншн!", message: "Вы не ввели информацию, которой бы Вы хотели поделиться с нами"), animated: true)
        }else{
            if name == "" {name = "anonymous"}
            NetworkManager.shared.sendReview(name: name!, content: review!)
        }
    }
}


//MARK: - Появение/Сокрытие клавиатуры
private extension UserAboutUsViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        scrollViewBottomConstraint.constant -= keyboardFrameValue.cgRectValue.height
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrameValue.cgRectValue.height + 50), animated: false)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        
        scrollViewBottomConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - by TextView-Delegate + Custom-for-placeholder
extension UserAboutUsViewController: UITextViewDelegate {
    
    func setTextViewPlaceholder() {
        reviewTextView.text = "Введите текст"
        reviewTextView.textColor = .systemGray4
        reviewTextView.font = UIFont(name: "System", size: 13)
        
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.systemGray4.cgColor
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.returnKeyType = .done
        reviewTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.text == "Введите текст" {
            reviewTextView.text = ""
            reviewTextView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}
