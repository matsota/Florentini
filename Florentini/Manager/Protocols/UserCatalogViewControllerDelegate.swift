//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 23.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation


protocol UserCatalogViewControllerDelegate: class {
    
    func transitionByMenu(_ class: CatalogViewController, _ menuType: MenuViewController.MenuType)
    
    func filtrationProductsByCategory(_ class: CatalogViewController, _ sender: DesignButton)
    
    func hideAndShowCategories(option: String)
    
}
