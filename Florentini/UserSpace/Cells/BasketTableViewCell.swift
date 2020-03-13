//
//  BasketTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 10.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Custom Protocol
protocol BasketTableViewCellDelegate: class {
    func sliderSelector(_ cell: BasketTableViewCell)
}

///
//protocol BasketTableViewCellDelegate: class {
//    func basketTableViewCell(_ cell: BasketTableViewCell, didToggleFavorite isFavorite: Bool)
//}
///

class BasketTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func quantitySliderSelector(_ sender: UISlider) {
        delegate?.sliderSelector(self)
    }
    
    func fill(name: String, price: Int, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = "\(price) грн"
        image(productImageView)
    }
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak private var productImageView: UIImageView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantitySlider: UISlider!
    
    ///
    weak var delegate: BasketTableViewCellDelegate?
    ///
}
