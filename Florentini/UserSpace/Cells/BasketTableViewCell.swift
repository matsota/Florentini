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
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantitySlider: UISlider!
    
    
    var productName: String?
    var productPrice: Int64?
    var productCategory: String?
    
    
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
    
    func fill(name: String, price: Int64, category: String, slider: Int64) {
        productNameLabel.text = name
        productName = name
        productPrice = price
        productCategory = category
        
        quantitySlider.value = Float(slider)
        productPriceLabel.text! = "\(price) грн"
        quantityLabel.text! = "\(Int64(quantitySlider.value)) шт"
        
//        image(productImageView) + , image: @escaping(UIImageView) -> Void
        
//        productImageView.image = UIImage(data: data as Data) + , data: Data
    }
    

    @IBOutlet weak private var productImageView: UIImageView!

    
    ///
    weak var delegate: BasketTableViewCellDelegate?
    ///
}
