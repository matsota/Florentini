//
//  UserFAQViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserFAQViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitionViewLeftConstraint.constant = -transitionView.bounds.width
        
    }
    
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func menuTapped(_ sender: UIButton) {
        slideMethod(for: transitionView, constraint: transitionViewLeftConstraint, dismissBy: transitionDismissButton)
    }
    
    //MARK: - Transition seletion
    @IBAction func transitionAccepted(_ sender: UIButton) {
        guard let title = sender.currentTitle,
        let view = transitionView,
        let constraint = transitionViewLeftConstraint,
        let button = transitionDismissButton else {return}

        transitionPerform(by: title, for: view, with: constraint, dismiss: button)
    }
    
    //MARK: - Transition Dismiss
    @IBAction private func transitionDismissTapped(_ sender: UIButton) {
        slideMethod(for: self.transitionView, constraint: self.transitionViewLeftConstraint, dismissBy: self.transitionDismissButton)
    }
    
    //MARK: Hide and show FAQs:
    
    //MARK: - Payment process
    @IBAction private func showHidePaymentProcessTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.paymentProcessDescriptionLabel.isHidden = !self.paymentProcessDescriptionLabel.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Payment ptions
    @IBAction private func showHidePaymentOptionsTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.paymentOptionsDescriptionStackView.isHidden = !self.paymentOptionsDescriptionStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Delivery process
    @IBAction private func showHideDeliveryProcessTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.deliveryProcessDescriptionStackView.isHidden = !self.deliveryProcessDescriptionStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Feedback options
    @IBAction private func showHideFeedbackTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.feedbackDescriptionLabel.isHidden = !self.feedbackDescriptionLabel.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Private
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    
    //MARK: - View
    @IBOutlet private weak var transitionView: UIView!
    
    //MARK: - StackView
    @IBOutlet private weak var paymentOptionsDescriptionStackView: UIStackView!
    @IBOutlet private weak var deliveryProcessDescriptionStackView: UIStackView!
    
    //MARK: - Button
    @IBOutlet private weak var transitionDismissButton: UIButton!
    
    //MARK: - Label Outlets
    @IBOutlet private weak var paymentProcessDescriptionLabel: UILabel!
    @IBOutlet private weak var feedbackDescriptionLabel: UILabel!
    
    //MARK: - Constraint
    @IBOutlet private weak var transitionViewLeftConstraint: NSLayoutConstraint!
    
}









//MARK: - Extensions


