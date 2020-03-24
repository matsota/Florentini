//
//  WorkerMainSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 20.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class WorkerMainSpaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForTransitionDelegate = self as PrepareForWorkerSIMTransitionDelegate
        transitionByMenuDelegate = self as WorkerSlideInMenuTransitionDelegate
    }
    
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        
        guard let workMenuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkMenuVC.rawValue) as? WorkerSlidingMenuVC else {return}
        workMenuVC.workMenuTypeTapped = { workMenuType in
            //                NavigationManager.shared.menuOptionPicked(menuType)
            self.menuOptionPicked(workMenuType)
        }
        workMenuVC.modalPresentationStyle = .overCurrentContext
        workMenuVC.transitioningDelegate = self
        present(workMenuVC, animated: true)
    }
    
    @IBAction func chatTapped(_ sender: UIButton) {
        chatTransition()
    }
    
    func menuOptionPicked(_ menuType: WorkerSlidingMenuVC.WorkMenuType) {
        switch menuType {
        case .orders:
            let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? WorkerMainSpaceViewController
            view.window?.rootViewController = ordersVC
            view.window?.makeKeyAndVisible()
        case .catalog:
            let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerCatalogVC.rawValue) as? WorkerCatalogViewController
            view.window?.rootViewController = catalogVC
            view.window?.makeKeyAndVisible()
        case .profile:
            let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerProfileVC.rawValue) as? WorkerProfileViewController
            view.window?.rootViewController = profileVC
            view.window?.makeKeyAndVisible()
        case .faq:
            print("feedback")
            let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersFAQVC.rawValue) as? WorkersFAQViewController
            view.window?.rootViewController = faqVC
            view.window?.makeKeyAndVisible()
        case .exit:
            print("signOut")
            self.present(self.alert.alertSignOut(success: {
                self.dismiss(animated: true) { self.exitApp()
                }
            }), animated: true)
        }
    }
    
    //MARK: Методы переходов
    func chatTransition() {
        print("chat")
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersChatVC.rawValue) as? WorkersChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    
    func exitApp() {
        let exitApp = storyboard?.instantiateInitialViewController()
        view.window?.rootViewController = exitApp
        view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: - Private:
    //MARK: - Methods
    
    //MARK: - Implementation
    private let transition = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    private weak var prepareForTransitionDelegate: PrepareForWorkerSIMTransitionDelegate?
    private weak var transitionByMenuDelegate: WorkerSlideInMenuTransitionDelegate?
    
    
}

extension WorkerMainSpaceViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}

extension WorkerMainSpaceViewController: PrepareForWorkerSIMTransitionDelegate {
    
    func showSlideInMethod(_ sender: UIButton) {
        
    }
    
    
}

extension WorkerMainSpaceViewController: WorkerSlideInMenuTransitionDelegate {
    
    func transitionBySlidingVC(_ class: UIViewController, _ menuType: WorkerSlidingMenuVC.WorkMenuType) {
        
    }
    
}