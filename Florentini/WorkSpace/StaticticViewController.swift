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
    
    //MARK: - Статистика
    
    //MARK: - Выбор количества покупок, относительно которых будет считаться постоянный покупатель. Default = 5
    @IBAction func regularCusmotersTapped(_ sender: UIButton) {
        self.present(self.alert.setNumber(success: { (number) in
            self.receiptsCountOfRegularCustomers = number
            self.regularCusmotersButton.setTitle("Постоянные Клиенты (больше \(self.receiptsCountOfRegularCustomers) покупок)", for: .normal)
            self.viewDidLoad()
        }), animated: true)
    }
    //MARK: - По частоте покупки
    @IBAction func byFrequencyTapped(_ sender: UIButton) {
        hideUnhideFrequency()
    }
    
    //MARK: - По Чекам
    @IBAction func byReceiptsTapped(_ sender: UIButton) {
        hideUnhideReceipts()
    }
    
    //MARK: Редактирование статистики по чекам.
    //MARK - Default = 3000
    @IBAction func receiptsOverSomePriceTapped(_ sender: UIButton) {
        self.present(self.alert.setNumber(success: { (number) in
            self.overSomePrice = number
            self.receiptsOverSomePriceButton.setTitle("Чеков на сумму > \(number) грн", for: .normal)
            self.viewDidLoad()
        }), animated: true)
    }
    //MARK - Default = 700
    @IBAction func receiptsLessSomePriceTapped(_ sender: UIButton) {
        self.present(self.alert.setNumber(success: { (number) in
            self.lessSomePrice = number
            self.receiptsLessSomePriceButton.setTitle("Чеков на сумму < \(number) грн", for: .normal)
            self.viewDidLoad()
        }), animated: true)
    }
    
    //MARK: - По популярности
    @IBAction func byPopularityTapped(_ sender: UIButton) {
        hideUnhidePopularity()
    }
    
    
    //MARK: - Implementation
    private let alert = UIAlertController()
    //    private var order = [DatabaseManager.Order]()
    //    private var orderAddition = [DatabaseManager.OrderAddition]()
    
    private var receiptsCountOfRegularCustomers = 5
    private var overSomePrice = 3000
    private var lessSomePrice = 700
    
    //MARK: - Labels
    @IBOutlet private weak var totalAmountLabel: UILabel!
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
    
    
    @IBOutlet private weak var overSomePriceLabel: UILabel!
    @IBOutlet private weak var lessSomePriceLabel: UILabel!
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
    @IBOutlet private weak var receiptOverSomePriceStackView: UIStackView!
    @IBOutlet private weak var receiptLessSomePriceStackView: UIStackView!
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
    @IBOutlet weak var regularCusmotersButton: UIButton!
    @IBOutlet weak var receiptsOverSomePriceButton: UIButton!
    @IBOutlet weak var receiptsLessSomePriceButton: UIButton!
}









//MARK: - Extensions:

//MARK: - For Overrides
private extension StaticticViewController {
    
    //MARK: Для ViewDidLoad
    func forViewDidLoad() {
        NetworkManager.shared.fetchArchivedOrders(success: { (receipts, additions, deletedData)  in
            //MARK: Total Amount
            let totalAmount = additions.map({$0.productPrice * $0.productQuantity}).reduce(0, +)
            self.totalAmountLabel.text = "\(totalAmount) грн"
            
            //MARK: Orders total, completed, deleted
            let ordersCompleted = receipts.count,
            ordersFailed = deletedData.count,
            totalOrders = ordersCompleted + ordersFailed,
            ordersCompletedPersentage = Int(Float(ordersCompleted)/Float(totalOrders) * 100.0),
            ordersFailedPersentage = Int(Float(ordersFailed)/Float(totalOrders) * 100.0)
            // - total
            self.totalOrdersLabel.text = "\(totalOrders)"
            // - completed
            self.ordersCompletedLabel.text = "\(ordersCompleted)"
            self.ordersCompletedPercentageLabel.text = "\(ordersCompletedPersentage)"
            // - deleted
            self.ordersFailedLabel.text = "\(ordersFailed)"
            self.ordersFailedPercentageLabel.text = "\(ordersFailedPersentage)"
            
            //MARK: Customers
            // - unique
            let uniqueCustomers = Set(receipts.map({$0.currentDeviceID})).count
            self.uniqueCustomersLabel.text = "\(uniqueCustomers)"
            // - regular
            var regularCustomers = Int()
            
            for i in receipts {
                NetworkManager.shared.fetchRegularCustomers(currentDeviceID: i.currentDeviceID) { (quantity) in
                    if quantity.count > 2 {
                        regularCustomers += 1
                    }
                }
            }
            
//            var allCustomers = "",
//            regularCustomers = Int()
//            for i in receipts {
//                allCustomers += "(\(i.currentDeviceID)), "
//                if allCustomers.countRegularCustomers(deviceID: i.currentDeviceID.lowercased()) > self.receiptsCountOfRegularCustomers {
//                    regularCustomers += 1
//                    receipt.map({$0.currentDeviceID}).
//                }
//            }
                        
            let regularCustumersPersentage = Int(Float(regularCustomers)/Float(uniqueCustomers) * 100.0)
            self.regularCustomersLabel.text = "\(regularCustomers)"
            self.regularCustomersPercentageLabel.text = "\(regularCustumersPersentage)"
            
            //MARK: for Receipts
            var allTotalPricesArray = receipts.map({$0.totalPrice})
            allTotalPricesArray.sort()
            guard let max = allTotalPricesArray.last, let min = allTotalPricesArray.first else {return}
            let average = Int(allTotalPricesArray.reduce(0, +))/allTotalPricesArray.count
            self.maxReceiptLabel.text = "\(max)"
            self.averageReceiptLabel.text = "\(average)"
            self.minReceiptLabel.text = "\(min)"
            
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
        
        //MARK: By Frequency
        NetworkManager.shared.fetchArchivedOrdersByCategory(success: { (bouquetData, apeiceData, giftData, stockData) in
            //MARK: По кагеориям
            let bouquets = bouquetData.count,
            apeices = apeiceData.count,
            gifts = giftData.count,
            stocks = stockData.count,
            total = bouquets + apeices + gifts,
            bouquetPercentage = Int(Double(bouquets)/Double(total) * 100.0),
            apeicePercentage = Int(Double(apeices)/Double(total) * 100.0),
            giftPercentage = Int(Double(gifts)/Double(total) * 100.0),
            stockPercentage = Int(Double(stocks)/Double(total) * 100.0),
            bouquetAmount = bouquetData.map({$0.productPrice * $0.productQuantity}).reduce(0, +),
            apeiceAmount = apeiceData.map({$0.productPrice * $0.productQuantity}).reduce(0, +),
            giftAmount = giftData.map({$0.productPrice * $0.productQuantity}).reduce(0, +),
            stockAmount = stockData.map({$0.productPrice * $0.productQuantity}).reduce(0, +),
            totalAmount = bouquetAmount + apeiceAmount + giftAmount,
            bouquetAmountPercentage = Int(Double(bouquetAmount)/Double(totalAmount) * 100.0),
            apeiceAmountPercentage = Int(Double(apeiceAmount)/Double(totalAmount) * 100.0),
            giftAmountPercentage = Int(Double(giftAmount)/Double(totalAmount) * 100.0),
            stockAmountPercentage = Int(Double(stockAmount)/Double(totalAmount) * 100.0)
            
            //MARK - Букеты
            self.bouquetFrequencyLabel.text = "\(bouquets)"
            self.bouquetFrequencyPercentageLabel.text = "\(bouquetPercentage)"
            self.amountOfBouquetsLabel.text = "\(bouquetAmount)"
            self.amountOfBouquetsPercentageLabel.text = "\(bouquetAmountPercentage)"
            //MARK - Цветы Поштучно
            self.flowerFrequencyLabel.text = "\(apeices)"
            self.flowerFrequencyPercentageLabel.text = "\(apeicePercentage)"
            self.amountOfFlowersLabel.text = "\(apeiceAmount)"
            self.amountOfFlowersPercentageLabel.text = "\(apeiceAmountPercentage)"
            //MARK - Подраки
            self.giftFrequencyLabel.text = "\(gifts)"
            self.giftFrequencyPercentageLabel.text = "\(giftPercentage)"
            self.amountOfGiftsLabel.text = "\(giftAmount)"
            self.amountOfGiftsPercentageLabel.text = "\(giftAmountPercentage)"
            //MARK - Акционные товары
            self.stockFrequencyLabel.text = "\(stocks)"
            self.stockFrequencyPercentageLabel.text = "\(stockPercentage)"
            self.amountOfStocksLabel.text = "\(stockAmount)"
            self.amountOfStocksPercentageLabel.text = "\(stockAmountPercentage)"
        }) { (error) in
            print("Error occured in fetchArchivedOrders",error.localizedDescription)
        }
        
        //MARK: By Reciepts
        NetworkManager.shared.fetchArchivedOrdersByReceipts(overThan: overSomePrice, lessThan: lessSomePrice, success: { (over, less)  in
            
            let biggerThan = over.count,
            lessThan = less.count
            
            self.overSomePriceLabel.text = "\(biggerThan)"
            self.lessSomePriceLabel.text = "\(lessThan)"
            
            
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
            self.receiptOverSomePriceStackView.isHidden = !self.receiptOverSomePriceStackView.isHidden
            self.receiptLessSomePriceStackView.isHidden = !self.receiptLessSomePriceStackView.isHidden
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
