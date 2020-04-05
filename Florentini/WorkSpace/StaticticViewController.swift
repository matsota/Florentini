//
//  StaticticViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 05.04.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit


class StaticticViewController: UIViewController {
    
    //MARK: - Overrides
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forViewDidLoad()
        
    }
    
    //MARK: - Стистика
    
    //MARK: - По частоте покупки
    @IBAction func byFrequencyTapped(_ sender: UIButton) {
        hideUnhideFrequency()
    }
    
    //MARK: - По Чекам
    @IBAction func byReceiptsTapped(_ sender: UIButton) {
        hideUnhideReceipts()
    }
    
    //MARK: Редактирование статистики по чекам
    @IBAction func receiptsOverSomePriceTapped(_ sender: UIButton) {
        self.present(self.alert.setNumber(success: { (number) in
            self.overSomePrice = number
            self.receiptsOverSomePriceButton.setTitle("Чеков на сумму > \(number) грн", for: .normal)
        }), animated: true)
    }
    @IBAction func receiptsLessSomePriceTapped(_ sender: UIButton) {
        self.present(self.alert.setNumber(success: { (number) in
            self.overSomePrice = number
            self.receiptsLessSomePriceButton.setTitle("Чеков на сумму < \(number) грн", for: .normal)
        }), animated: true)
    }
    
    //MARK: - По популярности
    @IBAction func byPopularityTapped(_ sender: UIButton) {
        hideUnhidePopularity()
    }
    
    
    //MARK: - Implementation
    private let alert = UIAlertController()
    private var order = [DatabaseManager.Order]()
    private var orderAddition = [DatabaseManager.OrderAddition]()
    
    private var overSomePrice = 3000
    private var lessSomePrice = 700
    
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
    @IBOutlet private weak var giftFrequencyPercentageLabel: UILabel!
    @IBOutlet private weak var amountOfGiftsLabel: UILabel!
    @IBOutlet private weak var amountOfGiftsPercentageLabel: UILabel!
    
    @IBOutlet private weak var stockFrequencyLabel: UILabel!
    @IBOutlet private weak var stockFrequencyPercentageLabel: UILabel!
    @IBOutlet private weak var amountOfStocksLabel: UILabel!
    @IBOutlet private weak var amountOfStocksPercentageLabel: UILabel!
    
    @IBOutlet private weak var maxReceiptLabel: UILabel!
    @IBOutlet private weak var averageReceiptLabel: UILabel!
    @IBOutlet private weak var minReceiptLabel: UILabel!
    
    @IBOutlet private weak var mostPopularProductLabel: UILabel!
    @IBOutlet private weak var lessPopularProductLabel: UILabel!
    
    @IBOutlet private weak var mostPopularBouquetLabel: UILabel!
    @IBOutlet private weak var lessPopularBouquetLabel: UILabel!
    
    @IBOutlet private weak var mostPopularFlowerLabel: UILabel!
    @IBOutlet private weak var lessPopularFlowerLabel: UILabel!
    
    @IBOutlet private weak var mostPopularGiftLabel: UILabel!
    @IBOutlet private weak var lessPopularGiftLabel: UILabel!
    
    
    //MARK: - Stack View
    //MARK: Frequency
    @IBOutlet private weak var bouquetFrequencyStackView: UIStackView!
    @IBOutlet private weak var flowerFrequencyStackView: UIStackView!
    @IBOutlet private weak var giftFrequencyStackView: UIStackView!
    @IBOutlet private weak var stockFrequencyStackView: UIStackView!
    //MARK: Receipts
    @IBOutlet private weak var recieptOverSomePriceStackView: UIStackView!
    @IBOutlet private weak var recieptLessSomePriceStackView: UIStackView!
    @IBOutlet private weak var maxReceiptStackView: UIStackView!
    @IBOutlet private weak var averageReceiptStackView: UIStackView!
    @IBOutlet private weak var minReceiptStackView: UIStackView!
    //MARK: Popularity
    @IBOutlet weak var mostPopularProductStackView: UIStackView!
    @IBOutlet weak var lessPopularProductStackView: UIStackView!
    @IBOutlet weak var mostPopularBouquetStackView: UIStackView!
    @IBOutlet weak var lessPopularBouquetStackView: UIStackView!
    @IBOutlet weak var mostPopularFlowerStackView: UIStackView!
    @IBOutlet weak var lessPopularFlowerStackView: UIStackView!
    @IBOutlet weak var mostPopularGiftStackView: UIStackView!
    @IBOutlet weak var lessPopularGiftStackView: UIStackView!
    
    
    //MARK: - Buttons
    @IBOutlet weak var receiptsOverSomePriceButton: UIButton!
    @IBOutlet weak var receiptsLessSomePriceButton: UIButton!
}









//MARK: - Extensions:

//MARK: - For Overrides
private extension StaticticViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NetworkManager.shared.fetchArchivedOrders(success: { info in
            self.order = info
            
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
        
        NetworkManager.shared.fetchArchivedOrdersAdditions(success: { info in
            self.orderAddition = info
            
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
    }
    
}


//MARK: - Hide-Unhide certain statistics
private extension StaticticViewController {
    
    func hideUnhideFrequency() {
        UIView.animate(withDuration: 0.3) {
            self.bouquetFrequencyStackView.isHidden = !self.bouquetFrequencyStackView.isHidden
            self.flowerFrequencyStackView.isHidden = !self.flowerFrequencyStackView.isHidden
            self.giftFrequencyStackView.isHidden = !self.giftFrequencyStackView.isHidden
            self.stockFrequencyStackView.isHidden = !self.stockFrequencyStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    func hideUnhideReceipts() {
        UIView.animate(withDuration: 0.3) {
            self.recieptOverSomePriceStackView.isHidden = !self.recieptOverSomePriceStackView.isHidden
            self.recieptLessSomePriceStackView.isHidden = !self.recieptLessSomePriceStackView.isHidden
            self.maxReceiptStackView.isHidden = !self.maxReceiptStackView.isHidden
            self.averageReceiptStackView.isHidden = !self.averageReceiptStackView.isHidden
            self.minReceiptStackView.isHidden = !self.minReceiptStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    func hideUnhidePopularity() {
        UIView.animate(withDuration: 0.3) {
            self.mostPopularProductStackView.isHidden = !self.mostPopularProductStackView.isHidden
            self.lessPopularProductStackView.isHidden = !self.lessPopularProductStackView.isHidden
            self.mostPopularBouquetStackView.isHidden = !self.mostPopularBouquetStackView.isHidden
            self.lessPopularBouquetStackView.isHidden = !self.lessPopularBouquetStackView.isHidden
            self.mostPopularFlowerStackView.isHidden = !self.mostPopularFlowerStackView.isHidden
            self.lessPopularFlowerStackView.isHidden = !self.lessPopularFlowerStackView.isHidden
            self.mostPopularGiftStackView.isHidden = !self.mostPopularGiftStackView.isHidden
            self.lessPopularGiftStackView.isHidden = !self.lessPopularGiftStackView.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
}
