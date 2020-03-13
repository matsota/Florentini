//
//  UserCatalogTableViewCell.swift
//  
//
//  Created by Andrew Matsota on 03.03.2020.
//

import UIKit

class UserCatalogTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!
    @IBOutlet weak private var productDescriptionTextView: UITextView!
    @IBOutlet weak private var descriptionView: UIView!
    private var category: String?
    
    
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
        guard let price = Int(productPriceLabel.text!) else {return}
        guard let category = category else {return}
        NetworkManager.shared.makePreOrder(name: productNameLabel.text!, price: price, category: category)
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
    
}
