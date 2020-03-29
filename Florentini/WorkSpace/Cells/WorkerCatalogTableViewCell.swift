//
//  WorkerCatalogTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 09.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol Worker-Catalog-ViewControllerDelegate

protocol WorkerCatalogTableViewCellDelegate: class {
    
    func editPrice(_ cell: WorkerCatalogTableViewCell)
    
    func editStockCondition(_ cell: WorkerCatalogTableViewCell)
    
}


//MARK: - Core Class
class WorkerCatalogTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    let alert = UIAlertController()
    var price = Int()
    var category = String()
    var stock = false
    
    weak var delegate: WorkerCatalogTableViewCellDelegate?
    
    //MARK: - Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var stockConditionLabel: UILabel!
    
    //MARK: - ImageView
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: - View
    @IBOutlet weak var descriptionView: UIView!
    
    //MARK: - Buttons
    @IBOutlet weak var productPriceButton: UIButton!
    
    //MARK: - Switch
    @IBOutlet weak var stockSwitch: UISwitch!
    
    
    //MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.5) {
            self.descriptionView.isHidden = !self.descriptionView.isHidden
        }
    }
    
    //MARK: - Price Editor
    @IBAction func priceTapped(_ sender: UIButton) {
        delegate?.editPrice(self)
    }
    
    @IBAction func stockCondition(_ sender: UISwitch) {
        delegate?.editStockCondition(self)
    }
    
    
    //MARK: - Заполнение Таблицы
    func fill(name: String, price: Int, category: String, description: String, stock: Bool, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceButton.setTitle("\(price) грн", for: .normal)
        
        self.price = price
        self.category = category
        
        productDescriptionLabel.text = description
        
        self.stock = stock
        if stock == true {
            stockSwitch.isOn = true
            stockConditionLabel.text = "Акционный товар"
            stockConditionLabel.textColor = .red
        }else{
            stockSwitch.isOn = false
            stockConditionLabel.text = "Акция отсутствует"
            stockConditionLabel.textColor = .black
            
        }
        
        image(productImageView)
    }
    
}
