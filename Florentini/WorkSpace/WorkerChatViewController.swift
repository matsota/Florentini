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
        
        //MARK: Подгрузка информации о сотруднике, для чата
        NetworkManager.shared.workersInfoLoad(success: { workerInfo in
            self.currentWorkerInfo = workerInfo
            self.currentWorkerInfo.forEach { workerInfo in
                self.name = workerInfo.name
                self.position = workerInfo.position
            }
        }) { error in
            print(error.localizedDescription)
        }
        
        //MARK: Подгрузка всех сообщений, что сотрудники оставляли в чате
        NetworkManager.shared.workersChatLoad(success: { messages in
            self.messagesArray = messages
            self.messageTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        //MARK: Подгрузка новых сообщений, что сотрудники оставляли в чате, в процессе пользования приложением.
        NetworkManager.shared.chatUpdate { newMessages in
            self.messagesArray.insert(newMessages, at: 0)
            self.messageTableView.reloadData()
        }
        
    }
    
    //MARK: - Menu Button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Message button
    @IBAction func typeMessage(_ sender: UIButton) {
        guard self.name != "" else {return}
        self.present(self.alert.alertSendMessage(), animated: true)
    }
    
    
    
    //MARK: - Private:
    
    //MARK: - Methods
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    private var currentWorkerInfo = [DatabaseManager.WorkerInfo]()
    private var messagesArray = [DatabaseManager.ChatMessages]()
    
    private var name = String()
    private var position = String()
    
    //MARK: - TableView Outlet
    @IBOutlet weak var messageTableView: UITableView!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.WorkerMessagesTVCell.rawValue, for: indexPath) as! WorkerMessagesTableViewCell
        let message = messagesArray[indexPath.row]
        cell.fill(name: message.name, content: message.content, date: "\(message.timeStamp)")
        
        return cell
    }
    
}

//MARK: -


