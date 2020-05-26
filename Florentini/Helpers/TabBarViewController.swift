//
//  TabBarViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 22.05.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.purpleColorOfEnterprise
        
        self.selectedIndex = 2
        
        let cartIndex = self.index(ofAccessibilityElement: 0)
    
    }

}
