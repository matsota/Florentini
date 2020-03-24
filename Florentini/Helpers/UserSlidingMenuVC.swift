//
//  MenuViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

extension UserSlidingMenuVC{
    enum MenuType: Int {
        case home
        case catalog
        case feedback
        case faq
        case website
        
    }
}

class UserSlidingMenuVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var menuTypeTapped: ((MenuType) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            print("dissmissing: \(menuType)")
            self?.menuTypeTapped?(menuType)
        }
    }

}
