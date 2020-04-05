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
    

    //MARK: - Implementation
    private var order = [DatabaseManager.Order]()
    private var orderAddition = [DatabaseManager.OrderAddition]()
    
    //MARK: - Labels
    @IBOutlet weak var totalOrders: UILabel!
    
    @IBOutlet weak var ordersCompleted: UILabel!
    @IBOutlet weak var ordersCompletedPercentage: UILabel!
    
    @IBOutlet weak var ordersFailed: UILabel!
    @IBOutlet weak var ordersFailedPercentage: UILabel!
    
    @IBOutlet weak var uniqueCustomers: UILabel!
    
    @IBOutlet weak var regularCustomers: UILabel!
    @IBOutlet weak var regularCustomersPercentage: UILabel!
    
    @IBOutlet weak var bouquetFrequency: UILabel!
    @IBOutlet weak var bouquetFrequencyPercentage: UILabel!
    
    @IBOutlet weak var flowerFrequency: UILabel!
    @IBOutlet weak var flowerFrequencyPercentage: UILabel!
    
    @IBOutlet weak var giftFrequency: UILabel!
    @IBOutlet weak var giftFrequencyPercentage: UILabel!
    
    @IBOutlet weak var stockFrequency: UILabel!
    @IBOutlet weak var stockFrequencyPercentage: UILabel!
    
    @IBOutlet weak var maxBill: UILabel!
    @IBOutlet weak var averageBill: UILabel!
    @IBOutlet weak var minBill: UILabel!
    
    @IBOutlet weak var mostPopularProduct: UILabel!
    @IBOutlet weak var lessPopularProduct: UILabel!
    
    @IBOutlet weak var mostPopularBouquet: UILabel!
    @IBOutlet weak var lessPopularBouquet: UILabel!
    
    @IBOutlet weak var mostPopularFlower: UILabel!
    @IBOutlet weak var lessPopularFlower: UILabel!
    
    @IBOutlet weak var mostPopularGift: UILabel!
    @IBOutlet weak var lessPopularGift: UILabel!
    
    
}
