//
//  UserHomeTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 25.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: - Protocol-User-Catalog-TableViewCell
protocol UserHomeTableViewCellDelegate: class {
    
    func addToCart(_ cell: UserHomeTableViewCell)
    
}

class UserHomeTableViewCell: UITableViewCell {

    //MARK: - Implementation
    var category: String?
    //delegate
    weak var delegate: UserHomeTableViewCellDelegate?
    
    //MARK: - View Outlets
    @IBOutlet weak var productDesriptionView: UIView!
    
    //MARK: - ImageView Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    
    //MARK: - Label Outlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func addToCart(_ sender: DesignButton) {
        delegate?.addToCart(self)
    }
    
    
    //MARK: -  Метод появления описания продукта
    func showDescription(){
        let showGesture = UITapGestureRecognizer()
        showGesture.addTarget(self, action: #selector(imageTapped(_ :)))
        cellImageView.addGestureRecognizer(showGesture)
    }
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.productDesriptionView.isHidden = false
        }
    }
    
    
    //MARK: - Метод исчезания описания продукта
    func hideDescription(){
        let hideGesture = UITapGestureRecognizer()
        hideGesture.addTarget(self, action: #selector(hideDescription(_ :)))
        productDesriptionView.addGestureRecognizer(hideGesture)
    }

    @objc func hideDescription(_ gestureRecognizer: (UITapGestureRecognizer)  -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.productDesriptionView.isHidden = true
        }
    }
    
    
    //MARK: - Заполнение Таблицы
    func fill(name: String, price: Int, description: String, category: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = "\(price)"
        productDescriptionLabel.text = description
        self.category = category
        image(cellImageView)
    }
}
