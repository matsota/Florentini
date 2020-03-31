//
//  UserHomeTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 25.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol-User-Catalog-TableViewCell
protocol UserHomeTableViewCellDelegate: class {
    
    func addToCart(_ cell: UserHomeTableViewCell)
    
}

class UserHomeTableViewCell: UITableViewCell {

    //MARK: - Implementation
    var category: String?
    var price = Int()
    var stock: Bool?
    //delegate
    weak var delegate: UserHomeTableViewCellDelegate?
    
    //MARK: - View Outlets
    @IBOutlet weak var productDesriptionView: UIView!
    
    //MARK: - ImageView Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    
    //MARK: - Label Outlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!

    //MARK: Activity Indicator
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    func fill(name: String, price: Int, description: String, category: String, stock: Bool, image: @escaping(UIImageView) -> Void, failure: @escaping(Error) -> Void) {
        self.price = price
        self.stock = stock
        self.category = category
    
        productNameLabel.text = name
        productPriceLabel.text = "\(self.price) грн"
        productDescriptionLabel.text = description
        
        image(cellImageView)
    }
}
