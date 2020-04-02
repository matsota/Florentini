//
//  EmployerOrdersTableViewCell.swift
//  Florentini
//
//  Created by Andrew Matsota on 28.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

protocol EmployerOrdersTableViewCellDelegate: class {
    func deliveryPicker (_ cell: EmployerOrdersTableViewCell)
}

class EmployerOrdersTableViewCell: UITableViewCell {

    //MARK: - Implementation
    var bill = Int()
    var orderKey = String()
    var deliveryPerson = String()
    var currentDeviceID = String()
    //
    weak var delegate: EmployerOrdersTableViewCellDelegate?
    
    //MARK: - Label
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feedbackOptionLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    //MARK: - Button
    @IBOutlet weak var deliveryPickerButton: DesignButton!
    
    //MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Override
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        CoreDataManager.shared.saveOrderPath(orderPath: orderKey)
    }
    
    
    @IBAction func deliveryPickerTapped(_ sender: DesignButton) {
        delegate?.deliveryPicker(self)
    }
    
    //MARK: - Заполнение таблицы
    func fill (bill: Int, orderKey: String, phoneNumber: String, adress: String, name: String, feedbackOption: String, mark: String, deliveryPerson: String, currentDeviceID: String) {
        
        self.bill = bill
        self.orderKey = orderKey
        self.deliveryPerson = deliveryPerson
        self.currentDeviceID = currentDeviceID
        
        billLabel.text = "\(self.bill) грн"
        phoneNumberLabel.text = phoneNumber
        adressLabel.text = adress
        nameLabel.text = name
        feedbackOptionLabel.text = feedbackOption
        markLabel.text = mark
        
        deliveryPickerButton.setTitle( self.deliveryPerson, for: .normal)
    }
    
}

