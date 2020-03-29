//
//  WorkerOrdersTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 28.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class WorkerOrdersTableViewCell: UITableViewCell {

    //MARK: - Implementation
    var bill = Int()
    var orderKey = String()
    
    //MARK: - Label
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feedbackOptionLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    
    //MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        CoreDataManager.shared.saveOrderPath(orderPath: orderKey)

    }
    
    
    //MARK: - Заполнение таблицы
    func fill (bill: Int, orderKey: String, phoneNumber: String, adress: String, name: String, feedbackOption: String, mark: String) {
        
        self.bill = bill
        self.orderKey = orderKey
        billLabel.text = "\(self.bill) грн"
        phoneNumberLabel.text = phoneNumber
        adressLabel.text = adress
        nameLabel.text = name
        feedbackOptionLabel.text = feedbackOption
        markLabel.text = mark
        
        
    }
    
}

