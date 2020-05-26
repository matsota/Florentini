//
//  AboutUsViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setTextViewPlaceholder(for: reviewTextView)
        hideKeyboardWhenTappedAround()
        
    }

    //MARK: - Send a review
    @IBAction private func sendReviewTapped(_ sender: UIButton) {
        reviewSent()
    }
    
    //MARK: - Private Implementation
    
    //MARK: ScrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: TextField
    @IBOutlet private weak var nameTextField: UITextField!
    
    //MARK: TextView
    @IBOutlet private weak var reviewTextView: UITextView!
    
    //MARK: Constraint
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!

}









//MARK: - Extensions


//MARK: - Review method
private extension AboutUsViewController {
    func reviewSent() {
        var name = nameTextField.text
        let content = reviewTextView.text
        
        if content == "" {
            self.present(UIAlertController.classic(title: "Эттеншн!", message: "Вы не ввели информацию, которой бы Вы хотели поделиться с нами"), animated: true)
        }else{
            if name == "" {name = "anonymous"}
            guard let currentDeviceID = CoreDataManager.shared.device else {return}
            let newReview = DatabaseManager.Review(name: name!, content: content!, uid: "\(currentDeviceID)", timeStamp: Date())
            NetworkManager.shared.sendReview(newReview: newReview, content: content!, success: {
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
private extension AboutUsViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        scrollViewBottomConstraint.constant -= keyboardFrameValue.cgRectValue.height
        scrollView.setContentOffset(CGPoint(x: 0, y: keyboardFrameValue.cgRectValue.height), animated: false)
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
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
extension AboutUsViewController: UITextViewDelegate {
    
    func setTextViewPlaceholder(for textView: UITextView) {
        textView.text = "Введите текст"
        textView.textColor = .systemGray3
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
    func textViewDidEndEditing(_ textView: UITextView) {
        setTextViewPlaceholder(for: reviewTextView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}
