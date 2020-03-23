//
//  CatalogViewController.swift
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
        delegate = self as UserFAQViewControllerDelegate
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
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? MenuViewController else {return}
        menuVC.menuTypeTapped = { menuType in
            self.delegate?.transitionByMenu(self, menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }
    
    //MARK: - Private
    weak private var delegate: UserFAQViewControllerDelegate?
    private let transition = SlideInTransition()
    
    //MARK: Label Outlets
    @IBOutlet weak private var paymentProcessDescriptionLabel: UILabel!
    @IBOutlet weak private var paymentOptionsDescriptionStackView: UIStackView!
    @IBOutlet weak private var deliveryProcessDescriptionStackView: UIStackView!
    @IBOutlet weak private var feedbackDescriptionLabel: UILabel!
    
    
}









//MARK: - Extensions
//MARK: extensions by UIVC-bTransitioningDelegate
extension UserFAQViewController: UIViewControllerTransitioningDelegate {
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
extension UserFAQViewController: UserFAQViewControllerDelegate {
    //MARK: Метод перехода в другой ViewController
    func transitionByMenu(_ class: UserFAQViewController, _ menuType: MenuViewController.MenuType) {
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
