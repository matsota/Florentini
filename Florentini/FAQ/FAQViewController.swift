//
//  FAQViewController .swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
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
    
    //MARK: - Private Implementation
    
    //MARK: StackView
    @IBOutlet private weak var paymentOptionsDescriptionStackView: UIStackView!
    @IBOutlet private weak var deliveryProcessDescriptionStackView: UIStackView!
    
    //MARK: Label Outlets
    @IBOutlet private weak var paymentProcessDescriptionLabel: UILabel!
    @IBOutlet private weak var feedbackDescriptionLabel: UILabel!
    
}
