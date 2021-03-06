//
//  HomeTableViewCellDelegate.swift
//  Florentini
//
//  Created by Andrew Matsota on 25.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

//MARK: - Protocol
protocol HomeTableViewCellDelegate: class {
    
    func addToCart(_ cell: HomeTableViewCell)
    
}

class HomeTableViewCell: UITableViewCell {

    //MARK: - Implementation
    var category: String?
    var price = Int()
    var stock: Bool?
    var productID: String?
    weak var delegate: HomeTableViewCellDelegate?
    
    //MARK: - View
    @IBOutlet weak var productDesriptionView: UIView!
    
    //MARK: - ImageView
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var myBackgroundImage: UIImageView!
    
    //MARK: - Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //MARK: Constraint
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    //MARK: Activity Indicator
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let darkBlur = UIBlurEffect(style: .prominent),
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = myBackgroundImage.bounds
        myBackgroundImage.addSubview(blurView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5) {
            self.productDesriptionView.isHidden = !self.productDesriptionView.isHidden
        }
    }

    @IBAction func addToCart(_ sender: DesignButton) {
        delegate?.addToCart(self)
    }

    //MARK: - Заполнение Таблицы
    func fill(id: String, name: String, price: Int, description: String, category: String, stock: Bool) {
        imageActivityIndicator?.startAnimating()
        imageActivityIndicator?.isHidden = false
        
        self.price = price ; self.stock = stock ; self.category = category ; self.productID = id
        
        let storagePath =  "\(NavigationCases.FirstCollectionRow.productImages.rawValue)/\(id)",
        storageRef = Storage.storage().reference(withPath: storagePath)
    
        productNameLabel.text = name
        productPriceLabel.text = "\(self.price) грн"
        productDescriptionLabel.text = description
        
        cellImageView.sd_setImage(with: storageRef, placeholderImage: nil) { (image, _, _, _) in
            self.imageActivityIndicator?.stopAnimating()
        }
    }
}
