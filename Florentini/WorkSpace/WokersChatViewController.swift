//
//  WorkersFAQViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class WorkersChastViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        
            }
            workMenuVC.modalPresentationStyle = .overCurrentContext
            workMenuVC.transitioningDelegate = self
            present(workMenuVC, animated: true)
        }
            
    
