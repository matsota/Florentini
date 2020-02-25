//
//  WorkersTableViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


enum WorkersMenuType: Int {
    case home
    case catalog
    case feedback
    case faq
    case website
    
}

class WorkersTableViewController: UITableViewController {

       var menuTypeTapped: ((WorkersMenuType) -> Void)?
       
       override func viewDidLoad() {
           super.viewDidLoad()
       }

       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           guard let menuType = WorkersMenuType(rawValue: indexPath.row) else {return}
           dismiss(animated: true) { [weak self] in
               print("dissmissing: \(menuType)")
               self?.menuTypeTapped?(menuType)
           }
       }
    
}
