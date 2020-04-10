//
//  UserCartTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 10.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol-Basket-TableViewCell
protocol UserCartTableViewCellDelegate: class {
    
    func sliderValue(_ cell: UserCartTableViewCell)
    
}

//MARK: - Core Class
class UserCartTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    var productName: String?
    var productPrice: Int?
    var productCategory: String?
    var stock: Bool?
    ///delegate
    weak var delegate: UserCartTableViewCellDelegate?
    
    
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
    
    //MARK: - Прокрутка Слайдера
    @IBAction func quantitySliderSelector(_ sender: UISlider) {
        delegate?.sliderValue(self)
    }
    
    //MARK: - Заполнение таблицы
    func fill(name: String, category: String, price: Int, slider: Int, stock: Bool, imageData: Data) {
       self.stock = stock
        
        if category == NavigationCases.ProductCategoriesCases.apiece.rawValue {
            self.quantitySlider.maximumValue = Float(NavigationCases.MaxQuantityByCategoriesCases.hundred.rawValue)
        }else{
            self.quantitySlider.maximumValue = Float(NavigationCases.MaxQuantityByCategoriesCases.five.rawValue)
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
