//
//  StaticticViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 05.04.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

class StaticticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared.fetchArchivedOrders(success: { info in
            self.order = info
            print(self.order)
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
        
        NetworkManager.shared.fetchArchivedOrdersAdditions(success: { info in
            self.orderAddition = info
            print(self.orderAddition)
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
        
    }
    
    
    @IBAction func byFrequencyTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.bouquetFrequencyStackView.isHidden = !self.bouquetFrequencyStackView.isHidden
            self.flowerFrequencyStackView.isHidden = !self.flowerFrequencyStackView.isHidden
            self.giftFrequencyStackView.isHidden = !self.giftFrequencyStackView.isHidden
            self.stockFrequencyStackView.isHidden = !self.stockFrequencyStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func byReceiptsTapped(_ sender: UIButton) {
        
    }
    

    //MARK: - Implementation
    private var order = [DatabaseManager.Order]()
    private var orderAddition = [DatabaseManager.OrderAddition]()
    
    //MARK: - Labels
    @IBOutlet private weak var totalOrdersLabel: UILabel!
    
    @IBOutlet private weak var ordersCompletedLabel: UILabel!
    @IBOutlet private weak var ordersCompletedPercentageLabel: UILabel!
    
    @IBOutlet private weak var ordersFailedLabel: UILabel!
    @IBOutlet private weak var ordersFailedPercentageLabel: UILabel!
    
    @IBOutlet private weak var uniqueCustomersLabel: UILabel!
    
    @IBOutlet private weak var regularCustomersLabel: UILabel!
    @IBOutlet private weak var regularCustomersPercentageLabel: UILabel!
    
    @IBOutlet private weak var bouquetFrequencyLabel: UILabel!
    @IBOutlet private weak var bouquetFrequencyPercentageLabel: UILabel!
    @IBOutlet private weak var amountOfBouquetsLabel: UILabel!
    @IBOutlet private weak var amountOfBouquetsPercentageLabel: UILabel!
    
    @IBOutlet private weak var flowerFrequencyLabel: UILabel!
    @IBOutlet private weak var flowerFrequencyPercentageLabel: UILabel!
    @IBOutlet private weak var amountOfFlowersLabel: UILabel!
    @IBOutlet private weak var amountOfFlowersPercentageLabel: UILabel!
    
    @IBOutlet private weak var giftFrequencyLabel: UILabel!
    @IBOutlet weak var giftFrequencyPercentageLabel: UILabel!
    @IBOutlet weak var amountOfGiftsLabel: UILabel!
    @IBOutlet weak var amountOfGiftsPercentageLabel: UILabel!
    
    @IBOutlet private weak var stockFrequencyLabel: UILabel!
    @IBOutlet weak var stockFrequencyPercentageLabel: UILabel!
    @IBOutlet weak var amountOfStocksLabel: UILabel!
    @IBOutlet weak var amountOfStocksPercentageLabel: UILabel!
    
    @IBOutlet private weak var maxReceiptLabel: UILabel!
    @IBOutlet weak var averageReceiptLabel: UILabel!
    @IBOutlet weak var minReceiptLabel: UILabel!
    
    @IBOutlet private weak var mostPopularProductLabel: UILabel!
    @IBOutlet weak var lessPopularProductLabel: UILabel!
    
    @IBOutlet private weak var mostPopularBouquetLabel: UILabel!
    @IBOutlet weak var lessPopularBouquetLabel: UILabel!
    
    @IBOutlet private weak var mostPopularFlowerLabel: UILabel!
    @IBOutlet private weak var lessPopularFlowerLabel: UILabel!
    
    @IBOutlet private weak var mostPopularGiftLabel: UILabel!
    @IBOutlet private weak var lessPopularGiftLabel: UILabel!
    
    
    //MARK: - Stack View
    @IBOutlet private weak var bouquetFrequencyStackView: UIStackView!
    @IBOutlet private weak var flowerFrequencyStackView: UIStackView!
    @IBOutlet private weak var giftFrequencyStackView: UIStackView!
    @IBOutlet private weak var stockFrequencyStackView: UIStackView!
    
    @IBOutlet private weak var maxReceiptStackView: UIStackView!
    @IBOutlet private weak var averageReceiptStackView: UIStackView!
    @IBOutlet private weak var minReceiptStackView: UIStackView!
    
    
}
