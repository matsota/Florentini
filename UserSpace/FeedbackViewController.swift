//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    let transition = SlideInTransition()
    private let secretCode = "/WorkSpace"
    private let secretCode2 = "Go/"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    @IBAction func menuTapped(_ sender: UIButton) {
        guard let menuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MenuVC.rawValue) as? MenuViewController else {return}
        menuVC.menuTypeTapped = { menuType in
//            NavigationManager.shared.menuOptionPicked(menuType)
                            self.menuOptionPicked(menuType)
        }
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.transitioningDelegate = self
        present(menuVC, animated: true)
    }


    func menuOptionPicked(_ menuType: MenuType) {
            switch menuType {
            case .home:
                print("website")
                let homeVC = storyboard?.instantiateInitialViewController()
                view.window?.rootViewController = homeVC
                view.window?.makeKeyAndVisible()
            case .catalog:
                print("catalog")
                let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.CatalogVC.rawValue) as? CatalogViewController
                view.window?.rootViewController = catalogVC
                view.window?.makeKeyAndVisible()
            case .feedback:
                print("feedback")
                let feedbackVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FeedbackVC.rawValue) as? FeedbackViewController
                view.window?.rootViewController = feedbackVC
                view.window?.makeKeyAndVisible()
            case .faq:
                print("feedback")
                let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.FAQVC.rawValue) as? FAQViewController
                view.window?.rootViewController = faqVC
                view.window?.makeKeyAndVisible()
            case .website:
                print("website")
            }
        }
    
//Review maker & enter into secret workSpace
    @IBAction func sendReviewTapped(_ sender: UIButton) {
        let name = nameTextField.text
        let review = reviewTextField.text
        
        if name == secretCode && review == secretCode2 {
            let loginWorkSpaceVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.LoginWorkSpaceVC.rawValue) as? LoginWorkSpaceViewController
            view.window?.rootViewController = loginWorkSpaceVC
            view.window?.makeKeyAndVisible()
            
        }else if name == "" || review == "" {
            
        }else{
            
        }
    }
    
    
}


    extension FeedbackViewController: UIViewControllerTransitioningDelegate {
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresented = true
            return transition
        }
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresented = false
            return transition
        }
    }

