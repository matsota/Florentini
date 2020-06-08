//
//  UserCatalogTableViewCell.swift
//  
//
//  Created by Andrew Matsota on 03.03.2020.
//

import UIKit
import FirebaseUI

//MARK: - Protocol
protocol CatalogTableViewCellDelegate: class {
    
    func addToCart(_ cell: CatalogTableViewCell)
    
}

//MARK: - Core Class
class CatalogTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    var category: String?
    var price = Int()
    var stock: Bool?
    //delegate
    weak var delegate: CatalogTableViewCellDelegate?
    
    //MARK: View
    @IBOutlet weak var descriptionView: UIView!
    
    //MARK: ImageView
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //MARK: - Activity Indicator
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    //MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5) {
            self.descriptionView.isHidden = !self.descriptionView.isHidden
        }
    }
    
    //MARK: - Add to cart
    @IBAction func addToBasketTapped(_ sender: DesignButton) {
        delegate?.addToCart(self)
    }
    
    //MARK: - Cells fill
    func fill(name: String, price: Int, description: String, category: String, stock: Bool) {
        imageActivityIndicator?.startAnimating()
        imageActivityIndicator?.isHidden = false
        
        
//        imageHeightConstraint.constant = productImageView.bounds.width
        self.stock = stock
        self.price = price
        self.category = category
        
        productNameLabel.text = name
        productPriceLabel.text = "\(self.price) грн"
        productDescriptionLabel.text = description
        
        let storagePath =  "\(NavigationCases.Product.imageCollection.rawValue)/\(name)",
        storageRef = Storage.storage().reference(withPath: storagePath)
        
        productImageView.sd_setImage(with: storageRef, placeholderImage: nil) { (image, _, _, _) in
            self.imageActivityIndicator?.stopAnimating()
            self.imageActivityIndicator?.isHidden = true
        }
    }
    
}
