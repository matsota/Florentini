//
//  UserCatalogTableViewCell.swift
//  
//
//  Created by Andrew Matsota on 03.03.2020.
//

import UIKit


//MARK: - Custom Protocol
protocol UserCatalogTableViewCellDelegate: class {
    func addToCart(_ cell: UserCatalogTableViewCell)
}

class UserCatalogTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak private var productDescriptionTextView: UITextView!
    @IBOutlet weak private var descriptionView: UIView!
    var category: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func hideDescriptionTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    @IBAction func addToBasketTapped(_ sender: UIButton) {
        delegate?.addToCart(self)
    }
    
    //MARK: -  Метод появления описания продукта и кнопки "Скрыть" / "добавить в корзину"
    func showDescription(){
        let imageGesture = UITapGestureRecognizer()
        imageGesture.addTarget(self, action: #selector(imageTapped(_ :)))
        productImageView.addGestureRecognizer(imageGesture)
    }
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = false
        }
    }
    
    //MARK: - Метод заполнения клетки
    func fill(name: String, price: Int, description: String, category: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = "\(price)"
        productDescriptionTextView.text = description
        self.category = category
        
        image(productImageView)
    }
    
    
    ///
    weak var delegate: UserCatalogTableViewCellDelegate?
    ///
    
}
