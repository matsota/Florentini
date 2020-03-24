//
//  WorkerMainSpaceViewControllerDelegate.swift
//  Florentini
//
//  Created by Andrew Matsota on 24.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


//MARK: COMMON PROTOCOLS:

//MARK: - Для подготовки к переходу между ViewController'ами
protocol PrepareForWorkerSIMTransitionDelegate: class {

    func showSlideInMethod(_ sender: UIButton)
    
}

//MARK: - Для Перехода между ViewController'ами

protocol WorkerSlideInMenuTransitionDelegate: class {

    func transitionBySlidingVC(_ class: UIViewController, _ menuType: WorkerSlidingMenuVC.WorkMenuType)

}



////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////



//MARK: PERSONAL PROTOCOLS:

