//
//  UserCatalogTableViewCell.swift
//  
//
//  Created by Andrew Matsota on 03.03.2020.
//

import UIKit

class UserCatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func hideDescriptionTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addToBasketTapped(_ sender: UIButton) {
        
    }
    
    func imageFill(image: UIImage){
        productImageView.image = image
    }
    
    func descriptionFill(name: String, price: String, description: String) {
        productNameLabel.text = name
        productPriceLabel.text = price
        productDescriptionTextView.text = description
        
    }

}
