//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class NavigationManager: UINavigationController {
   
    //MARK: Системные переменные
    static let shared = NavigationManager()
    
//    let transition = SlideInTransition()
    
    
    //MARK: Enums for ViewControllers
    enum IDVC: String, CaseIterable {
        
        //for clients
        case CatalogVC = "CatalogVC"
        case FeedbackVC = "FeedbackVC"
        case FAQVC = "FAQVC"
        
        case MenuVC = "MenuVC"
   
        //for workers
        case LoginWorkSpaceVC = "LoginWorkSpaceVC"
        case MainWorkSpaceVC = "MainWorkSpaceVC"
        case WorkerCatalogVC = "WorkerCatalogVC"
        case WorkerProfileVC = "WorkerProfileVC"
        case WorkersFAQVC = "WorkersFAQVC"
        case WorkersChatVC = "WorkersChatVC"
        
        case WorkMenuVC = "WorkMenuVC"
    }
    
    
//    func workerChatTransition() {
//        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersChatVC.rawValue) as? WorkersChatViewController
//        view.window?.rootViewController = workersChatVC
//        view.window?.makeKeyAndVisible()
//    }
    
    func workerCatalogTransition() {
        let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerCatalogVC.rawValue) as? WorkerCatalogViewController
        view.window?.rootViewController = catalogVC
        view.window?.makeKeyAndVisible()
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
    
}

//
//extension NavigationManager: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.isPresented = true
//        return transition
//    }
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.isPresented = false
//        return transition
//    }
//}
    

