//
//  EmployerProfileViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmployerProfileViewController: UIViewController {
    
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
    
    //MARK: - Перехрод в Чат
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToEmployerChat()
    }
    
    //MARK: - Переход в Моделирование продукта
    @IBAction func changePasswordTapped(_ sender: DesignButton) {
        passwordView.isHidden = !passwordView.isHidden
    }
    
    //MARK: - Изменение пароля сотрудника
    @IBAction func passwordConfirmTapped(_ sender: UIButton) {
        changesConfirmed()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    
    private var currentWorkerInfo = [DatabaseManager.WorkerInfo]()
    
    //MARK: - View
    @IBOutlet weak var passwordView: UIView!
    
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

//MARK: - For Overrides
private extension EmployerProfileViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        //MARK:  Заполнение UI относительно CurrentUser
        NetworkManager.shared.downloadEmployerInfo(success: { workerInfo in
            self.currentWorkerInfo = workerInfo
            self.currentWorkerInfo.forEach { (workerInfo) in
                self.nameLabel.text = workerInfo.name
                self.positionLabel.text = workerInfo.position
                
                if workerInfo.position == NavigationCases.WorkerInfoCases.admin.rawValue && AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid{
                    self.newProductButton.isHidden = false
                }
            }
            self.emailLabel.text = Auth.auth().currentUser?.email
        }) { error in
            self.present(self.alert.somethingWrong(), animated: true)
        }
    }
    
}

//MARK: - UIVC-TransitioningDelegate
extension EmployerProfileViewController: UIViewControllerTransitioningDelegate {
    
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

//MARK: - Change Password
private extension EmployerProfileViewController{
    
    func changesConfirmed() {
        guard let newPass = newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let reNewPass = reNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        
        if newPass != reNewPass {
            self.present(self.alert.classic(title: "Внимание", message: "Пароли не совпадают"), animated: true)
        }else if newPass == "" || reNewPass == "" {
            self.present(self.alert.classic(title: "Внимание", message: "Для смены пароля необходимо заполнить все поля"), animated: true)
        }else{
            self.present(self.alert.rePassword(success: {
                self.dismiss(animated: true) { let ordersVC = self.storyboard?.instantiateViewController(withIdentifier: NavigationCases.IDVC.EmployerOrdersVC.rawValue) as? EmployerOrdersViewController
                    self.view.window?.rootViewController = ordersVC
                    self.view.window?.makeKeyAndVisible()
                }
            }, password: newPass), animated: true)
        }
    }
    
}

//MARK: -

