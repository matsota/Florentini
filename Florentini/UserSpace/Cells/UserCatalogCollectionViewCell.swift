//
//  UserCatalogCollectionViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 29.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class UserCatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageVIew: UIImageView!
    @IBOutlet weak var layerView: UIView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    @IBAction func hideDescriptionTapped(_ sender: UIButton) {
        self.layerView.isHidden = true
    }
    
    @IBAction func basketTapped(_ sender: UIButton) {
    }
    
    
    func fill (image: UIImageView, name: String, price: String, description: String){
        productImageVIew.image = image.image
        productNameLabel.text = name
        productPriceLabel.text = price
        productDescriptionTextView.text = description
        
    }
}
