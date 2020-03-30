//
//  UserBasketTableViewCell.swift
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
    var productPrice: Int64?
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
    func fill(name: String, price: Int64, slider: Int64, stock: Bool, imageData: NSData) {
       self.stock = stock
        
        productNameLabel.text = name
        productName = name
        productPrice = price
        
        quantitySlider.value = Float(slider)
        productPriceLabel.text! = "\(price) грн"
        quantityLabel.text! = "\(Int64(quantitySlider.value)) шт"
        
        productImageView.image = UIImage(data: imageData as Data)
    }
    
}
