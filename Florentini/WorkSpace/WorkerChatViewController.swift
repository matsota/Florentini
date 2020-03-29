//
//  WorkersChatViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import Firebase

class WorkerChatViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Информация о сотруднике
        NetworkManager.shared.workersInfoLoad(success: { workerInfo in
            self.currentWorkerInfo = workerInfo
            self.currentWorkerInfo.forEach { workerInfo in
                self.name = workerInfo.name
                self.position = workerInfo.position
            }
        }) { error in
            print(error.localizedDescription)
        }
        
        //MARK: Сообщения чата
        NetworkManager.shared.workersChatLoad(success: { messages in
            self.messagesArray = messages
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        //MARK: Обновление чата
        NetworkManager.shared.chatUpdate { newMessages in
            self.messagesArray.insert(newMessages, at: 0)
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: - Menu Button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Message button
    @IBAction func typeMessage(_ sender: UIButton) {
        guard name != "" else {return}
        self.present(self.alert.alertSendMessage(name: name), animated: true)
    }
    
    
    
    //MARK: - Private:
 
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    private var currentWorkerInfo = [DatabaseManager.WorkerInfo]()
    private var messagesArray = [DatabaseManager.ChatMessages]()
    
    private var name = String()
    private var position = String()
    
    //MARK: - TableView Outlet
    @IBOutlet weak var tableView: UITableView!
    
}









//MARK: - Extensions:

//MARK: - by UIVC-TransitioningDelegate
extension WorkerChatViewController: UIViewControllerTransitioningDelegate {
    
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
extension WorkerChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerMessagesTVCell.rawValue, for: indexPath) as! WorkerMessagesTableViewCell,
        message = messagesArray[indexPath.row]
        
        cell.fill(name: message.name, content: message.content, date: "\(message.timeStamp)")
        
        return cell
    }
    
}

//MARK: -


