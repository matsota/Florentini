//
//  LoginWorkSpaceViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class LoginWorkSpaceViewController: UIViewController {
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Вход в рабочую зону
    @IBAction func signInTapped(_ sender: UIButton) {
        signIn()
    }
    
    //MARK: - Private:
    
    //MARK: - Implementation
    private let alert = UIAlertController()
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
       
}









//MARK: - Extension

//MARK: - Аунтефикация

private extension LoginWorkSpaceViewController {
    
    func transition() {
        let transition = storyboard?.instantiateViewController(identifier: NavigationManager.IDVC.MainWorkSpaceVC.rawValue) as? WorkerMainSpaceViewController
        view.window?.rootViewController = transition
        view.window?.makeKeyAndVisible()
    }

    func signIn(){
        let email = loginTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        AuthenticationManager.shared.signIn(email: email, password: password, success: {
            self.transition()
        }) { error in
            self.present(self.alert.alertClassicInfoOK(title: "Attention", message: error.localizedDescription), animated: true)
        }
    }
    
}
