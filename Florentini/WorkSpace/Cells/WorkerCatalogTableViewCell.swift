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
    weak var delegate: WorkerCatalogTableViewCellDelegate?
    
    var category = String()
    
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
        
        // Configure the view for the selected state
    }
    
    //MARK: - Price Editor
    @IBAction func priceTapped(_ sender: UIButton) {
        delegate?.editPrice(self)
    }
    
    //MARK: - Hide Description Button
    @IBAction func stopDescribeTapped(_ sender: DesignButton) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
    }
    
    //MARK: -  Метод появления описания продукта и кнопки
    func showDescription(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(imageTapped(_ :)))
        productImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = false
        }
    }
    
    //MARK: - Метод исчезания описания продукта
    func hideDescription(){
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(hideDescription(_ :)))
        productDescriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideDescription(_ gestureRecognizer: (UITapGestureRecognizer)  -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.descriptionView.isHidden = true
        }
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
