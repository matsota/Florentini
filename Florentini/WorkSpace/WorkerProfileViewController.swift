//
//  WorkerProfileViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseAuth

class WorkerProfileViewController: UIViewController {
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWorkerData()
        
    }
    
    //MARK: - Menu Button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Open Chat Button
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    //MARK: - Add New Product Button
    @IBAction func newProductTapped(_ sender: UIButton) {
        transitionToNewProduct()
    }
    
    //MARK: - Change Password Button
    @IBAction func passChangeTapped(_ sender: UIButton) {
        changePassword()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    private var currentWorkerInfo = [DatabaseManager.WorkerInfo]()
    
    //MARK: - Button Outlet
    @IBOutlet weak private var newProductButton: UIButton!
    
    //MARK: - Label Outlet
    @IBOutlet weak private var positionLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    
    //MARK: - TextField Outlet
    @IBOutlet private weak var newPassword: UITextField!
    @IBOutlet private weak var reNewPassword: UITextField!
    
    
}









//MARK: - Extention:

//MARK: - UIVC-TransitioningDelegate
extension WorkerProfileViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: -

//MARK: - Заполнение UI относительно CurrentUser
private extension WorkerProfileViewController {
    
    func fetchWorkerData() {
        NetworkManager.shared.workersInfoLoad(success: { workerInfo in
            self.currentWorkerInfo = workerInfo
            self.currentWorkerInfo.forEach { (workerInfo) in
                self.nameLabel.text = workerInfo.name
                self.positionLabel.text = workerInfo.position
                
                if workerInfo.position == NavigationCases.WorkerInfoCases.admin.rawValue && AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid {
                    self.newProductButton.isHidden = false
                }
            }
            self.emailLabel.text = Auth.auth().currentUser?.email
        }) { error in
            self.present(self.alert.alertSomeThingGoesWrong(), animated: true)
        }
    }
    
}

//MARK: - Change Password
private extension WorkerProfileViewController{
    
    func changePassword() {
        guard let newPass = newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let reNewPass = reNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        
        if newPass != reNewPass {
            self.present(self.alert.alertClassicInfoOK(title: "Внимание", message: "Пароли не совпадают"), animated: true)
        }else if newPass == "" || reNewPass == "" {
            self.present(self.alert.alertClassicInfoOK(title: "Внимание", message: "Для смены пароля необходимо заполнить все поля"), animated: true)
        }else{
            self.present(self.alert.alertPassChange(success: {
                self.dismiss(animated: true) { let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.MainWorkSpaceVC.rawValue) as? WorkerOrdersViewController
                    self.view.window?.rootViewController = ordersVC
                    self.view.window?.makeKeyAndVisible()
                }
            }, password: newPass), animated: true)
        }
    }
    
}

//MARK: - Метод перехода на страницу создания продуктов

private extension WorkerProfileViewController {
    
    func transitionToNewProduct() {
        let catalogVC = storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.NewProductSetVC.rawValue) as? NewProductSetViewController
        view.window?.rootViewController = catalogVC
    }
    
}

