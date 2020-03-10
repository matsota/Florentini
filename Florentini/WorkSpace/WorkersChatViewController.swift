//
//  WorkersChatViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import Firebase

class WorkersChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - TableView Outlet
    @IBOutlet weak var messageTableView: UITableView!
    
    //MARK: - Системные переменные
    let transition = SlideInTransition()
    let alert = UIAlertController()
    
    var currentWorkerInfo = [DatabaseManager.WorkerInfo]()
    var messagesArray = [DatabaseManager.ChatMessages]()
    
    //MARK: - ViewDidLoad Method
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
        NetworkManager.shared.workersMessagesLoad(success: { messages in
            self.messagesArray = messages
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        }) { error in
            print(error.localizedDescription)
        }
        
        //MARK: Подгрузка новых сообщений, что сотрудники оставляли в чате, в процессе пользования приложением.
        NetworkManager.shared.chatUpdate { newMessages in
            self.messagesArray.insert(newMessages, at: 0)
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        }
    }
    
    //MARK: - Menu Button
    @IBAction func workerMenuTapped(_ sender: Any) {
        guard let workMenuVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkMenuVC.rawValue) as? WorkMenuViewController else {return}
        workMenuVC.workMenuTypeTapped = { workMenuType in
            self.menuOptionPicked(workMenuType)
        }
        workMenuVC.modalPresentationStyle = .overCurrentContext
        workMenuVC.transitioningDelegate = self
        present(workMenuVC, animated: true)
    }
    
    //MARK: - Menu Options
    func menuOptionPicked(_ menuType: WorkMenuType) {
        switch menuType {
        case .orders:
            ordersTransition()
        case .catalog:
            catalogTransition()
        case .profile:
            profileTransition()
        case .faq:
            faqTransition()
        case .exit:
            print("signOut")
            self.present(self.alert.alertSignOut(success: {
                self.dismiss(animated: true) { self.exitApp()
                }
            }), animated: true)
        }
    }
    
    
    //MARK: - Table View Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationManager.IDVC.WorkerMessagesTVCell.rawValue, for: indexPath) as! WorkerMessagesTableViewCell
        let message = messagesArray[indexPath.row]
        cell.fill(name: message.name, content: message.content, date: "\(message.timeStamp)")
        
        return cell
    }
    
    //MARK: - Message button
    @IBAction func typeMessage(_ sender: UIButton) {
        guard self.name != "" else {return}
        self.present(self.alert.alertSendMessage(), animated: true)
    }
    
    //MARK: - Методы переходов
    //чат
    func chatTransition() {
        print("chat")
        let workersChatVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersChatVC.rawValue) as? WorkersChatViewController
        view.window?.rootViewController = workersChatVC
        view.window?.makeKeyAndVisible()
    }
    //заказы
    func ordersTransition() {
        print("orders")
        let ordersVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? MainWorkSpaceViewController
        view.window?.rootViewController = ordersVC
        view.window?.makeKeyAndVisible()
    }
    //каталог
    func catalogTransition() {
        print("catalog")
        let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerCatalogVC.rawValue) as? WorkerCatalogViewController
        view.window?.rootViewController = catalogVC
        view.window?.makeKeyAndVisible()
    }
    //профиль
    func profileTransition() {
        print("profile")
        let profileVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkerProfileVC.rawValue) as? WorkerProfileViewController
        view.window?.rootViewController = profileVC
        view.window?.makeKeyAndVisible()
    }
    //часто задаваемые вопросы
    func faqTransition() {
        print("feedback")
        let faqVC = storyboard?.instantiateViewController(withIdentifier: NavigationManager.IDVC.WorkersFAQVC.rawValue) as? WorkersFAQViewController
        view.window?.rootViewController = faqVC
        view.window?.makeKeyAndVisible()
    }
    //выход
    func exitApp() {
        let exitApp = storyboard?.instantiateInitialViewController()
        view.window?.rootViewController = exitApp
        view.window?.makeKeyAndVisible()
    }
    
    //MARK: - Implementation
    private var name = String()
    private var position = String()
    
}



//MARK: - Out of Class
//MARK: - Extensions
extension WorkersChatViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresented = false
        return transition
    }
}


