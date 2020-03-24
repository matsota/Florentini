//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

extension WorkerSlidingMenuVC {
    enum WorkMenuType: Int {
        case orders
        case catalog
        case profile
        case faq
        case exit
        
    }
}
class WorkerSlidingMenuVC: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var workMenuTypeTapped: ((WorkMenuType) -> Void)?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workMenuType = WorkMenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) { [weak self] in
            print("dissmissing: \(workMenuType)")
            self?.workMenuTypeTapped?(workMenuType)
        }
    }
    
}
