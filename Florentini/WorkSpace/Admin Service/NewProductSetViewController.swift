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

class NewProductSetViewController: UIViewController {
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        setTextViewPlaceholder()
    }
    
    //MARK: - Кнопка меню
    @IBAction func menuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    //MARK: - Кнопка перехода в чат
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    //MARK: - Кнопка загрузки фотографии по ссылке
    @IBAction func downLoadByURLTapped(_ sender: UIButton) {
        downloadByURL()
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
        uploadingProduct()
    }
    
    //MARK: - Private:
    
    //MARK: - Methods

    //MARK: - Implementation
    private let cases = DatabaseManager.ProductCategoriesCases.allCases.map{$0.rawValue}
    private var selectedCategory = DatabaseManager.ProductCategoriesCases.none.rawValue
    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    private let alert = UIAlertController()
    private var givenUrl: URL?
    
    //MARK: - TextField Outelets
    @IBOutlet private weak var photoNameTextField: UITextField!
    @IBOutlet private weak var photoPriceTextField: UITextField!
    @IBOutlet private weak var photoDescriptionTextView: UITextView!
    
    //MARK: - ProgressView
    @IBOutlet private weak var progressView: UIProgressView!
    
    //MARK: - PickerView
    @IBOutlet private weak var photoCategoryPickerView: UIPickerView!
    
    //MARK: - ImageView
    @IBOutlet private weak var addedPhotoImageView: UIImageView!
    
    //MARK: - ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: - Constraints
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
}









//MARK: - Extension:

//MARK: - by PickerView
extension NewProductSetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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

//MARK: - by TextView-Delegate + Custom-for-placeholder
extension NewProductSetViewController: UITextViewDelegate {
    
    func setTextViewPlaceholder() {
        photoDescriptionTextView.text = "Введите текст"
        photoDescriptionTextView.textColor = .lightGray
        photoDescriptionTextView.font = UIFont(name: "System", size: 13)
        
        photoDescriptionTextView.layer.borderWidth = 1
        photoDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        photoDescriptionTextView.returnKeyType = .done
        photoDescriptionTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if photoDescriptionTextView.text == "Введите текст" {
            photoDescriptionTextView.text = ""
            photoDescriptionTextView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}

//MARK: -

//MARK: - Создание изображение для товара с помощью камеры телефона + с помощью галлереи телефона

extension NewProductSetViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    
    
    func downLoadPhoto() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
            //after it is complete
        }
    }
    
}

//MARK: - Поиск фотографии по ссылке из сети
extension NewProductSetViewController {
    
    func downloadByURL() {
        self.present(self.alert.setImageByURL { url in
            NetworkManager.shared.downLoadImageByURL(url: url) { image in
                self.addedPhotoImageView.image = image
            }
        }, animated: true)
    }
    
}

//MARK: - Загрузка продукта в сеть
extension NewProductSetViewController {
    
    func uploadingProduct() {
        
            let price = Int(photoPriceTextField.text!),
                image = addedPhotoImageView,
                name = self.photoNameTextField.text,
                description = self.photoDescriptionTextView.text
        
        if price == nil || image == nil || name == "" || description == "" {
            self.present(self.alert.alertClassicInfoOK(title: "Эттеншн", message: "Вы ввели не все данные. Перепроверьте свой результат"), animated: true)
        }else if selectedCategory == DatabaseManager.ProductCategoriesCases.none.rawValue {
            self.present(self.alert.alertClassicInfoOK(title: "Эттеншн", message: "Вы не выбрали категорию продукта."), animated: true)
        }else{
            NetworkManager.shared.uploadProduct(image: image!, name: name!, progressIndicator: progressView)  {
                NetworkManager.shared.setProductDescription(name: name!, price: price!, category: self.selectedCategory, description: description!, documentNamedID: name!)
            }
        }
    }
    
}

//MARK: - Keyboard

extension NewProductSetViewController {
    
    //Movement constrains for keyboard
    @objc private func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        scrollViewBottomConstraint.constant = -keyboardFrameValue.cgRectValue.height
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: false)
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        
        scrollViewBottomConstraint.constant = 14
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
}
