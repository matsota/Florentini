//
//  UserFAQViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserFAQViewController: UIViewController {
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func showHidePaymentProcessTapped(_ sender: UIButton) {
        paymentProcessDescriptionLabel.isHidden = !paymentProcessDescriptionLabel.isHidden
        
    }
    
    @IBAction func showHidePaymentOptionsTapped(_ sender: UIButton) {
        paymentOptionsDescriptionStackView.isHidden = !paymentOptionsDescriptionStackView.isHidden
    }
    
    @IBAction func showHideDeliveryProcessTapped(_ sender: UIButton) {
        deliveryProcessDescriptionStackView.isHidden = !deliveryProcessDescriptionStackView.isHidden
    }
    
    @IBAction func showHideFeedbackTapped(_ sender: UIButton) {
        feedbackDescriptionLabel.isHidden = !feedbackDescriptionLabel.isHidden
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        showUsersSlideInMethod()
    }
    
    //MARK: - Private
    
    //MARK: - Methods
    
    
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    
    //MARK: Label Outlets
    @IBOutlet private weak var paymentProcessDescriptionLabel: UILabel!
    @IBOutlet private weak var paymentOptionsDescriptionStackView: UIStackView!
    @IBOutlet private weak var deliveryProcessDescriptionStackView: UIStackView!
    @IBOutlet private weak var feedbackDescriptionLabel: UILabel!
    
    
}









//MARK: - Extensions
//MARK: - Появление SlidingMenu
extension UserFAQViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

