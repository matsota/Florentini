//
//  WorkerMainSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 20.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


class WorkerOrdersViewController: UIViewController {
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadMainOrderInfo(success: { (orders) in
            self.order = orders
            self.tableView.reloadData()
        }) { error in
            self.present(self.alert.alertClassicInfoOK(title: "Attention", message: error.localizedDescription), animated: true)
        }
        
        NetworkManager.shared.updateOrders { newOrder in
            self.order.insert(newOrder, at: 0)
            self.tableView.reloadData()
        }
        
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
    private var order = [DatabaseManager.Order]()
    
    //MARK: - TableView
    @IBOutlet weak var tableView: UITableView!
    
}









//MARK: - Extension:

//MARK: - UIVC-TransitioningDelegate
extension WorkerOrdersViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: - by TableView
extension WorkerOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerOrdersTVCell.rawValue, for: indexPath) as! WorkerOrdersTableViewCell,
        fetch = order[indexPath.row]
        
        cell.fill(bill: Int(fetch.totalPrice), orderKey: fetch.deviceID, phoneNumber: fetch.cellphone, adress: fetch.adress, name: fetch.name, feedbackOption: fetch.feedbackOption, mark: fetch.mark)
        
        return cell
    }
    
}

