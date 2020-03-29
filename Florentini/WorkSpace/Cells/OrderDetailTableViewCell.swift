//
//  OrderDetailTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 29.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    //MARK: - Imp[lementation
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            }
    
    func fill (name: String, quantity: Int, category: String, price: Int, stock: Bool, image: @escaping(UIImageView) -> Void) {
        
        nameLabel.text = name
        quantityLabel.text = "\(quantity) единиц"
        categoryLabel.text = category
        priceLabel.text = "\(price) грн"
        
        if stock == true {
            stockLabel.text = "Да"
            stockLabel.textColor = .red
        }else{
            stockLabel.text = "Нет"
            stockLabel.textColor = .black
        }
        
        image(images)
    }

}
