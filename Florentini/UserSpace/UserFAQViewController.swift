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
        
    }

    
    //MARK: - Нажатие кнопки Меню
    @IBAction func menuTapped(_ sender: UIButton) {
        showUsersSlideInMethod()
    }
    
    //MARK: - Показать/Спрятать Ответ на вопрос из FAQ
    
    //MARK: Процесс оплаты
    @IBAction func showHidePaymentProcessTapped(_ sender: UIButton) {
        paymentProcessDescriptionLabel.isHidden = !paymentProcessDescriptionLabel.isHidden
        
    }
    //MARK: Варианты Оплаты
    @IBAction func showHidePaymentOptionsTapped(_ sender: UIButton) {
        paymentOptionsDescriptionStackView.isHidden = !paymentOptionsDescriptionStackView.isHidden
    }
    //MARK: Процесс Доставки
    @IBAction func showHideDeliveryProcessTapped(_ sender: UIButton) {
        deliveryProcessDescriptionStackView.isHidden = !deliveryProcessDescriptionStackView.isHidden
    }
    //MARK: Способы Обратной связи
    @IBAction func showHideFeedbackTapped(_ sender: UIButton) {
        feedbackDescriptionLabel.isHidden = !feedbackDescriptionLabel.isHidden
    }
    
    //MARK: - Private
 
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    
    //MARK: Label Outlets
    @IBOutlet private weak var paymentProcessDescriptionLabel: UILabel!
    @IBOutlet private weak var paymentOptionsDescriptionStackView: UIStackView!
    @IBOutlet private weak var deliveryProcessDescriptionStackView: UIStackView!
    @IBOutlet private weak var feedbackDescriptionLabel: UILabel!
    
}









//MARK: - Extensions

//MARK: - For Overrides
private extension UserFAQViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
    }
    
}

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

