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
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func menuTapped(_ sender: UIButton) {
        slideInTransitionMenu(for: transitionView, constraint: transitionViewLeftConstraint, dismissBy: transitionDismissButton)
    }
    
    //MARK: - Transition confim
    @IBAction private func transitionConfim(_ sender: UIButton) {
        guard let title = sender.currentTitle,
            let view = transitionView,
            let constraint = transitionViewLeftConstraint,
            let button = transitionDismissButton else {return}
        
        transitionPerform(by: title, for: view, with: constraint, dismiss: button)
    }
    
    //MARK: - Transition Dismiss
    @IBAction private func transitionDismissTapped(_ sender: UIButton) {
        slideInTransitionMenu(for: self.transitionView, constraint: self.transitionViewLeftConstraint, dismissBy: self.transitionDismissButton)
    }
    
    //MARK: - Send a review
    @IBAction private func sendReviewTapped(_ sender: UIButton) {
        reviewSent()
    }
    
    //MARK: - Private Implementation
    
    //MARK: ScrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: View
    @IBOutlet private weak var transitionView: UIView!
    
    //MARK: Button
    @IBOutlet private weak var transitionDismissButton: UIButton!
    
    //MARK: TextField
    @IBOutlet private weak var nameTextField: UITextField!
    
    //MARK: TextView
    @IBOutlet private weak var reviewTextView: UITextView!
    
    //MARK: Constraint
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var transitionViewLeftConstraint: NSLayoutConstraint!
    
}









//MARK: - Extensions

//MARK: - For Overrides
private extension UserAboutUsViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        
        setTextViewPlaceholder(for: reviewTextView)
        
    }
    
}

//MARK: - Review method
private extension UserAboutUsViewController {
    func reviewSent() {
        var name = nameTextField.text
        let content = reviewTextView.text
        
        if content == "" {
            self.present(UIAlertController.classic(title: "Эттеншн!", message: "Вы не ввели информацию, которой бы Вы хотели поделиться с нами"), animated: true)
        }else{
            if name == "" {name = "anonymous"}
            NetworkManager.shared.sendReview(name: name!, content: content!, success: {
                self.present(UIAlertController.completionDoneTwoSec(title: "Благодарим Вас", message: "Мы очень рады, что у нас есть возможность заняться самоанализом!"), animated: true)
                self.nameTextField.text = ""
                self.reviewTextView.text = ""
                self.viewDidLoad()
            }) { (error) in
                print("Error in UserAboutUsViewController, review: ", error.localizedDescription)
                self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Произошла неизвестная ошибка, попробуйте повторить еще раз"), animated: true)
            }
        }
    }
}

//MARK: - Hide and Show Any
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

//MARK: - TextView Delegate + Custom
extension UserAboutUsViewController: UITextViewDelegate {
    
    func setTextViewPlaceholder(for textView: UITextView) {
        textView.text = "Введите текст"
        textView.textColor = .systemGray4
        textView.font = UIFont(name: "System", size: 13)
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 5
        textView.returnKeyType = .done
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Введите текст" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}
