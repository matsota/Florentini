//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 23.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation


protocol UserAboutUsViewControllerDelegate: class {
    
    func transitionByMenu(_ class: UserAboutUsViewController, _ menuType: MenuViewController.MenuType)
    
}


