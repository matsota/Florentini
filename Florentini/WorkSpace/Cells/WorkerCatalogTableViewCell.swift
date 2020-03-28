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
}


//MARK: - Core Class
class WorkerCatalogTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    let alert = UIAlertController()
    var category = String()
    
    weak var delegate: WorkerCatalogTableViewCellDelegate?
    
    //MARK: - Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //MARK: - ImageView
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: - View
    @IBOutlet weak var descriptionView: UIView!
    
    //MARK: - Buttons
    @IBOutlet weak var productPriceButton: UIButton!
    
    
    
    //MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

    //MARK: - Заполнение Таблицы
    func fill(name: String, price: Int, category: String, description: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceButton.setTitle("\(price) грн", for: .normal)
        self.category = category
        productDescriptionLabel.text = description
        image(productImageView)
    }
    
}
