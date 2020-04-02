//
//  EmployerSlidingMenuVC.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

extension EmployerSlidingMenuVC {
    enum EmployerMenuType: Int {
        case orders
        case catalog
        case profile
        case faq
        case exit
        
    }
}
class EmployerSlidingMenuVC: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var employerMenuTypeTapped: ((EmployerMenuType) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let employerMenuType = EmployerMenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            self?.employerMenuTypeTapped?(employerMenuType)
        }
    }
    
}
