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
    
    
    //MARK: - Outlets
    //MARK: ImageView
    @IBOutlet weak var productImageView: UIImageView!
    //MARK: Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    //MARK: - var/let
    var category: String?
    
    weak var delegate: UserCatalogTableViewCellDelegate?
    
    //MARK: - Override methods
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Кнопка 'Скрыть Описание'
    @IBAction func hideDescriptionTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    
    //MARK: - Кнопка 'Добавить в корзину'
    @IBAction func addToBasketTapped(_ sender: UIButton) {
        delegate?.addToCart(self)
    }
    
    //MARK: -  Метод появления описания продукта и кнопки 'Скрыть/Добавить в корзину'
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
        productPriceLabel.text = "\(price) грн"
        productDescriptionLabel.text = description
        self.category = category
        
        image(productImageView)
    }
    
    
    //MARK: - Private Outlet
    //MARK: View
    @IBOutlet weak private var descriptionView: UIView!
    
}
