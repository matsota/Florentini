//
//  BasketTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 10.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

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
        delegate?.sliderValue(self)
    }
    
    func fill(name: String, price: Int64, slider: Int64, imageData: NSData) {
        productNameLabel.text = name
        productName = name
        productPrice = price
        
        quantitySlider.value = Float(slider)
        productPriceLabel.text! = "\(price) грн"
        quantityLabel.text! = "\(Int64(quantitySlider.value)) шт"
        
        productImageView.image = UIImage(data: imageData as Data)
    }
    

    @IBOutlet weak private var productImageView: UIImageView!

    
    ///
    weak var delegate: BasketTableViewCellDelegate?
    ///
}
