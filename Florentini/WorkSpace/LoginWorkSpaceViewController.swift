//
//  LoginWorkSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class LoginWorkSpaceViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        let email = loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        AuthenticationManager.shared.signIn(email: email, password: password, success: {
            self.transitionToMainWorkVC()
        }) { error in
            self.present(self.alert.alertClassicInfoOK(title: "Attention", message: error.localizedDescription), animated: true)
        }
        
    }
    
    ///Элементы метода signInTapped
    //MARK: Переход в профиль
    func transitionToMainWorkVC() {
        let MainWorkSpaceVC = storyboard?.instantiateViewController(identifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? MainWorkSpaceViewController
        view.window?.rootViewController = MainWorkSpaceVC
        view.window?.makeKeyAndVisible()
    }
    
}
