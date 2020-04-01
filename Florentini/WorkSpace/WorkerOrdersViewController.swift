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
    var jsonArray: [[String: Any]] = []
    
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
    private var orderAdditions = [DatabaseManager.OrderAddition]()
    
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
        fetch = order[indexPath.row],
        bill = Int(fetch.totalPrice),
        orderKey = fetch.deviceID,
        phoneNumber = fetch.cellphone,
        adress = fetch.adress,
        name = fetch.name,
        feedbackOption = fetch.feedbackOption,
        mark = fetch.mark
        
        cell.fill(bill: bill, orderKey: orderKey, phoneNumber: phoneNumber, adress: adress, name: name, feedbackOption: feedbackOption, mark: mark)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let fetch = order[indexPath.row],
        totalPrice = fetch.totalPrice,
        name = fetch.name,
        adress = fetch.adress,
        cellphone = fetch.cellphone,
        feedbackOption = fetch.feedbackOption,
        mark = fetch.mark,
        timeStamp = fetch.timeStamp,
        id = fetch.deviceID,
        
        action = UIContextualAction(style: .destructive, title: "Архив") { (action, view, complition) in
            self.present(self.alert.alertArchiveOrder(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, id: id, success: {
                NetworkManager.shared.archiveOrderAddition(orderKey: id)
                self.present(self.alert.succeedFinish(title: "Отлично!", message: "Заказ Удачно архивирован"), animated: true)
                self.order.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                self.present(self.alert.succeedFinish(title: "Эттеншн", message: "Заказ успершно архивирован"), animated: true)
                complition(true)
            }), animated: true)
        }
        return action
    }
    
}

