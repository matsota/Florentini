//
//  WorkerCatalogTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 09.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol Worker-Catalog-ViewControllerDelegate

protocol WorkerCatalogTableViewCellDelegate: class {
    
    func deleteProduct(name: String)
    
}


//MARK: - Core Class
class WorkerCatalogTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    let alert = UIAlertController()
    weak var delegate: WorkerCatalogTableViewCellDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var deteleButton: UIButton!
    
    
    //MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - Hide Description Button
    @IBAction func hideDiscriptionTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    //MARK: - Delete Description Button
    @IBAction func deleteDescriptionTapped(_ sender: UIButton) {
        guard let name = productNameLabel.text else {return}
        delegate?.deleteProduct(name: name)
    }
    
    //MARK: -  Метод появления описания продукта и кнопки "Скрыть" / "добавить в корзину"
    func showDescription(){
        let imageGesture = UITapGestureRecognizer()
        imageGesture.addTarget(self, action: #selector(imageTapped(_ :)))
        productImageView.addGestureRecognizer(imageGesture)
    }
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = false
        }
        
        if AuthenticationManager.shared.currentUser?.uid == AuthenticationManager.shared.uidAdmin {
            self.deteleButton.isHidden = false
        }
    }
    
    //MARK: - Заполнение Таблицы
    func fill(name: String, price: Int, description: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = "\(price)"
        productDescriptionTextView.text = description
        image(productImageView)
    }
    
    
}
