//
//  UserCatalogCollectionViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 29.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserCatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak private var layerView: UIView!
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!
    @IBOutlet weak private var productDescriptionTextView: UITextView!
    
    
    
    //MARK: Спрятать описание продукта
    @IBAction func hideDescriptionTapped(_ sender: UIButton) {
        self.layerView.isHidden = true
    }
    
    @IBAction func addToBasketTapped(_ sender: UIButton) {
    }
    
    func fill (name: String, price: String, description: String, image: UIImage){
        productNameLabel.text = name
        productPriceLabel.text = price
        productDescriptionTextView.text = description
        productImageView.image = image
    }
}
