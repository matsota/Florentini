//
//  UserCatalogTableViewCell.swift
//  
//
//  Created by Andrew Matsota on 03.03.2020.
//

import UIKit

//MARK: - Protocol-User-Catalog-TableViewCell
protocol UserCatalogTableViewCellDelegate: class {
    
    func addToCart(_ cell: UserCatalogTableViewCell)
    
}

//MARK: - Core Class
class UserCatalogTableViewCell: UITableViewCell {
    
    //MARK: - Implementation
    var category: String?
    //delegate
    weak var delegate: UserCatalogTableViewCellDelegate?
    
    //MARK: View
    @IBOutlet weak var descriptionView: UIView!
    
    //MARK: ImageView
    @IBOutlet weak var productImageView: UIImageView!
    
    //MARK: Label
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!

    
    //MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - Спрятать описание продукта
    @IBAction func stopDescribeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    //MARK: - Добавление в Корзину
    @IBAction func addToBasketTapped(_ sender: DesignButton) {
        delegate?.addToCart(self)
    }
    
    //MARK: -  Метод появления описания продукта
    func showDescription(){
        let showGesture = UITapGestureRecognizer()
        showGesture.addTarget(self, action: #selector(imageTapped(_ :)))
        productImageView.addGestureRecognizer(showGesture)
    }
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = false
        }
    }
    
    
    //MARK: - Метод исчезания описания продукта
    func hideDescription(){
        let hideGesture = UITapGestureRecognizer()
        hideGesture.addTarget(self, action: #selector(hideDescription(_ :)))
        descriptionView.addGestureRecognizer(hideGesture)
    }

    @objc func hideDescription(_ gestureRecognizer: (UITapGestureRecognizer)  -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    //MARK: - Заполнение Таблицы
    func fill(name: String, price: Int, description: String, category: String, image: @escaping(UIImageView) -> Void) {
        productNameLabel.text = name
        productPriceLabel.text = "\(price)"
        productDescriptionLabel.text = description
        self.category = category
        
        image(productImageView)
    }
    
}
