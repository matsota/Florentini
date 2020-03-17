//
//  NewProductSetViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 27.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewProductSetViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let db = Firestore.firestore()
    //MARK: - TextField Outelet
    @IBOutlet weak var photoNameTextField: UITextField!
    @IBOutlet weak var photoPriceTextField: UITextField!
    @IBOutlet weak var photoCategoryPickerView: UIPickerView!
    @IBOutlet weak var photoDescriptionTextField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: - ImageView Outlet
    @IBOutlet weak var addedPhotoImageView: UIImageView!
    
    
    //MARK: - System var&let
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    let alert = UIAlertController()
    var givenUrl: URL?
    
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - Кнопка меню
    @IBAction func menuTapped(_ sender: UIButton) {
    }
    
    //MARK: - Кнопка перехода в чат
    @IBAction func chatTapped(_ sender: UIButton) {
    }
    
    //MARK: - Кнопка загрузки фотографии по ссылке
    @IBAction func downLoadByURLTapped(_ sender: UIButton) {
        self.present(self.alert.setImageByURL { url in
            NetworkManager.shared.downLoadImageByURL(url: url) { image in
                self.addedPhotoImageView.image = image
            }
        }, animated: true)
    }
    
    //MARK: - Кнопка загрузки фотографии из галлерии
    @IBAction func galleryTapped(_ sender: UIButton) {
        downLoadPhoto()
    }
    
    //MARK: - Кнопка загрузки фотографии со снимка Камеры телефона
    @IBAction func cameraTapped(_ sender: UIButton) {
        makePhoto()
    }
    
    //MARK: - Кнопка загрузки фотографии в Firebase
    @IBAction func uploadTapped(_ sender: UIButton) {
        let name = self.photoNameTextField.text!
        guard let price = Int(photoPriceTextField.text!) else {return}
        let category = selectedCategory
        let description = self.photoDescriptionTextField.text!
        
        guard let image = addedPhotoImageView else {return}
        
        NetworkManager.shared.uploadPhoto(image: image, name: name, progressIndicator: progressView)  {
            guard let category = category else {return}
            NetworkManager.shared.setProductDescription(name: name, price: price, category: category, description: description, documentNamedID: name)
        }
    }
    
    //MARK: - Созданить изображение для товара с помощью галлереи телефона
    func downLoadPhoto() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
            //after it is complete
        }
    }
    
    //MARK: - Созданить изображение для товара с помощью камеры телефона
    func makePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.camera
            image.allowsEditing = false
            
            self.present(image, animated: true){
                //after it is complete        }
            }
        }else{
            self.present(self.alert.alertClassicInfoOK(title: "Внимание", message: "Камера не доступна"), animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.addedPhotoImageView.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TEST AREA
    
    
    
    //MARK: - Transition Methods
    
    
    //MARK: - Private
    private let cases = DatabaseManager.ProductCategoriesCases.allCases.map{$0.rawValue}
    private var selectedCategory: String?
}


extension NewProductSetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if pickerView == photoCategoryPickerView {return DatabaseManager.ProductCategoriesCases.allCases.count}
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == photoCategoryPickerView {return cases[row]}
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == photoCategoryPickerView {return cases.count}
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == photoCategoryPickerView {
            selectedCategory = cases[row]
        }
    }
    
    
}
