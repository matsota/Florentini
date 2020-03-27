//
//  WorkerMainSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 20.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class WorkerMainSpaceViewController: UIViewController {

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Transition Menu tapped
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Chat Transition tapped
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
}









//MARK: - Extension:

//MARK: - UIVC-TransitioningDelegate
extension WorkerMainSpaceViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: -

