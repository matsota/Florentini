//
//  BasketTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 10.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

///
protocol BasketTableViewCellDelegate: class {
    func deleteFromBasketTableViewCell(_ cell: BasketTableViewCell)
}
///
//protocol BasketTableViewCellDelegate: class {
//    func basketTableViewCell(_ cell: BasketTableViewCell, didToggleFavorite isFavorite: Bool)
//}
class BasketTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteProductFromBasket(_ sender: UIButton) {
        let name = productNameLabel.text!
        NetworkManager.shared.deletePreOrderProduct(name: name) {
        }
    }
    
    func fill(name: String, price: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = price
        
        image(productImageView)
    }
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!
    @IBOutlet weak private var productImageView: UIImageView!
    
    ///
    weak var delegate: BasketTableViewCellDelegate?
    ///
    
}
