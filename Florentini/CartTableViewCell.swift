//
//  CartTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 10.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol-Basket-TableViewCell
protocol CartTableViewCellDelegate: class {
    
    func sliderValue(_ cell: CartTableViewCell)
    
}

//MARK: - Core Class
class CartTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    var productName: String?
    var productPrice: Int?
    var productCategory: String?
    var stock: Bool?
    weak var delegate: CartTableViewCellDelegate?
    
    
    //MARK: ImageView
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    //MARK: Slider
    @IBOutlet weak var quantitySlider: UISlider!

    
    
    //MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Slider selecting
    @IBAction func quantitySliderSelector(_ sender: UISlider) {
        delegate?.sliderValue(self)
    }
    
    //MARK: - Cells fill
    func fill(name: String, category: String, price: Int, slider: Int, stock: Bool, imageData: Data) {
       self.stock = stock
        
        if category == NavigationCases.ProductCategories.flower.rawValue {
            self.quantitySlider.maximumValue = Float(NavigationCases.MaxSliderValueByCategories.twentyFive.rawValue)
        }else{
            self.quantitySlider.maximumValue = Float(NavigationCases.MaxSliderValueByCategories.five.rawValue)
        }
        
        productNameLabel.text = name
        productName = name
        productPrice = price
        
        quantitySlider.setValue(Float(slider), animated: true)
        productPriceLabel.text! = "\(price * slider) грн"
        quantityLabel.text! = "\(slider) шт"
        
        
        productImageView.image = UIImage(data: imageData)
    }
    
}
