//
//  AuthenticationManager.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import Firebase


class AuthenticationManager {
    
    //MARK: - Системные переменные
    static var shared = AuthenticationManager()
    let currentUser = Auth.auth().currentUser
    let uidAdmin = "Q0Lh49RsIrMU8itoNgNJHN3bjmD2"
    
    //MARK: - Метод SignIn
    func signIn(email: String, password: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                failure(error!)
            }
            else{
                success()
            }
        }
        
    }
    
    //MARK: - Метод SignUp для Клиентов
    //    func signsUp(email: String, password: String, firstName: String, lastName: String, phone: String, success: @escaping() -> Void, failure: @escaping(Error) ->Void) {
    //
    //        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
    //            if error != nil {
    //                failure(error!)
    //            }else{
    //                let uid = result!.user.uid
    //                NetworkManager.shared.db.collection("users").document(uid).setData(["first name" : firstName, "last name" : lastName, "phone" : phone, "uid" : uid])
    //                success()
    //            }
    //        }
    //    }
    
    //    //MARK: - Sign In Anonymously
    //    func signInAnonymously() {
    //        let auth = Auth.auth()
    //
    //        auth.signInAnonymously { (result, error) in
    //            if let error = error {
    //                print ("error: \(error.localizedDescription)")
    //                return
    //            }
    //            let uid = result?.user.uid
    //            print("success: \(String(describing: uid))")
    //        }
    //    }
    
    //MARK: - Метод SignOut
    func signOut() {
        try! Auth.auth().signOut()
    }
    
    //MARK: - Метод смены пароля:
    func passChange(password: String) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: nil)
    }
    
}

