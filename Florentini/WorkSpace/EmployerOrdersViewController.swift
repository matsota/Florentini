//
//  WorkerMainSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 20.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


class EmployerOrdersViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        
    }
    
    //MARK: - Нажатие кнопки Меню
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Переход в Чат
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    private var order = [DatabaseManager.Order]()
    private var orderCount = Int()
    private var orderAdditions = [DatabaseManager.OrderAddition]()
    
    //MARK: - TableView
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Label
    @IBOutlet weak var ordersCountLabel: UILabel!
    
}









//MARK: - Extension:

//MARK: - For Overrides
private extension EmployerOrdersViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NetworkManager.shared.downloadMainOrderInfo(success: { (orders) in
            self.order = orders
            self.orderCount = orders.count
            self.ordersCountLabel.text = "Orders: \(self.orderCount)"
            self.tableView.reloadData()
        }) { error in
            self.present(self.alert.classic(title: "Attention", message: error.localizedDescription), animated: true)
        }
        
        NetworkManager.shared.updateOrders { newOrder in
            self.order.insert(newOrder, at: 0)
            self.orderCount += 1
            self.viewDidLoad()
        }
    }
    
}

//MARK: - UIVC-TransitioningDelegate
extension EmployerOrdersViewController: UIViewControllerTransitioningDelegate {
    
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
extension EmployerOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerOrdersTVCell.rawValue, for: indexPath) as! WorkerOrdersTableViewCell,
        fetch = order[indexPath.row],
        bill = Int(fetch.totalPrice),
        orderKey = fetch.currentDeviceID,
        phoneNumber = fetch.cellphone,
        adress = fetch.adress,
        name = fetch.name,
        feedbackOption = fetch.feedbackOption,
        mark = fetch.mark,
        currentDeviceID = fetch.currentDeviceID,
        deliveryPerson = fetch.deliveryPerson
        
        cell.delegate = self
        
        cell.fill(bill: bill, orderKey: orderKey, phoneNumber: phoneNumber, adress: adress, name: name, feedbackOption: feedbackOption, mark: mark, deliveryPerson: deliveryPerson, currentDeviceID: currentDeviceID)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archive = archiveAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [archive])
    }
    
    func archiveAction(at indexPath: IndexPath) -> UIContextualAction {
        let fetch = order[indexPath.row],
        totalPrice = fetch.totalPrice,
        name = fetch.name,
        adress = fetch.adress,
        cellphone = fetch.cellphone,
        feedbackOption = fetch.feedbackOption,
        mark = fetch.mark,
        timeStamp = fetch.timeStamp,
        id = fetch.currentDeviceID,
        deliveryPerson = fetch.deliveryPerson,
        
        action = UIContextualAction(style: .destructive, title: "Архив") { (action, view, complition) in
            self.present(self.alert.orderArchive(totalPrice: totalPrice, name: name, adress: adress, cellphone: cellphone, feedbackOption: feedbackOption, mark: mark, timeStamp: timeStamp, id: id, deliveryPerson: deliveryPerson, success: {
                NetworkManager.shared.archiveOrderAddition(orderKey: id)
                self.present(self.alert.dataUploadedDelay2(title: "Отлично!", message: "Заказ Удачно архивирован"), animated: true)
                self.orderCount -= 1
                self.order.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.viewDidLoad()
                self.present(self.alert.dataUploadedDelay2(title: "Эттеншн", message: "Заказ успершно архивирован"), animated: true)
                complition(true)
            }), animated: true)
        }
        return action
    }
    
}

//MARK: - Назначение Доставки
extension EmployerOrdersViewController: WorkerOrdersTableViewCellDelegate {
    
    func deliveryPicker(_ cell: WorkerOrdersTableViewCell) {
        let currentDeviceID = cell.currentDeviceID
        
        self.present(self.alert.editDeliveryPerson(currentDeviceID: currentDeviceID, success: { (deliveryPerson) in
            cell.deliveryPickerButton.setTitle(deliveryPerson, for: .normal)
        }), animated:  true)
        self.tableView.reloadData()
    }
    
}

