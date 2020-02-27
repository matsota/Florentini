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
    @IBOutlet weak var photoCategoryTextField: UITextField!
    @IBOutlet weak var photoDescriptionTextField: UITextField!
    
    //MARK: - ImageView Outlet
    @IBOutlet weak var addedPhotoImageView: UIImageView!
    
    
    //MARK: - System var&let
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    var givenUrl: URL?
    
    
    //MARK: - ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - Menu button
    @IBAction func menuTapped(_ sender: UIButton) {
    }
    
    //MARK: - Chat button
    @IBAction func chateTapped(_ sender: UIButton) {
    }
    
    //MARK: - Photo Download by URL
    @IBAction func downLoadByURLTapped(_ sender: UIButton) {
    }
    
    //MARK: - Photo in Gallery
    @IBAction func galleryTapped(_ sender: UIButton) {
        downLoadPhoto()
    }
    
    //MARK: - Photo by Camera
    @IBAction func cameraTapped(_ sender: UIButton) {
    }
    
    //MARK: - Photo Uploading
    @IBAction func uploadTapped(_ sender: UIButton) {
        guard let image = addedPhotoImageView.image else {return}
        uploadPhoto(image: image) { url in
            self.imageData(name: self.photoNameTextField.text!, url: url) { success in
                if success == true{
                    print("well played andrii")
                }
            }
        }
        
    }
    
    
    //MARK: - Test Area
    
    func uploadPhoto(image: UIImage, complition: @escaping(String) -> Void) {
//        guard let uid = AuthenticationManager.shared.currentUser?.uid else {return}
        let storageRef =  Storage.storage().reference().child("ProductPhotos/\(photoNameTextField.text!)")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/ipg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil {
                storageRef.downloadURL { (url, _) in
                    guard let url = url?.absoluteString else {return}
                    complition(url)
                }
            }
        }
    }
    
    
    
    func imageData(name: String, url: String, complition: @escaping ((_ success: Bool) -> ())) {
        
        let shablon = [
            "name": name,
            "url": url
        ] as [String: Any]
           
        db.collection("photos").document(self.photoNameTextField.text!).setData(shablon, merge: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.addedPhotoImageView.image = image
        
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePhotoInfo(name: String, price: Double, category: String, description: String, uidImage: String) {
        
    }

    
    //MARK: - Transition Methods
    
    
    
}
