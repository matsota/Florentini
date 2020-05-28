//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

struct filterCellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class CatalogViewController: UIViewController {
    
    //MARK: - Override
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.downloadProductsInfo(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.catalogTableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
        filterData = [filterCellData(opened: false, title: NavigationCases.ProductCategories.flower.rawValue, sectionData: flowers),
                      filterCellData(opened: false, title: NavigationCases.ProductCategories.bouquet.rawValue, sectionData: bouqets),
                      filterCellData(opened: false, title: NavigationCases.ProductCategories.gift.rawValue, sectionData: gifts)]
        
    }
    
    let gifts = ["Все", "Вазы", "Гелиевые шарики", "Сладкое", "Корзины", "Фруктовые корзины", "Козины из сладостей", "Мягкие игрушки", "Открытки", "Торты"]
    let flowers = ["Все", "Амараллис", "Ананас", "Антуриум", "Альстромерия", "Бамбук", "Брассика", "Бруния", "Ванда", "Гвоздика", "Гербера", "Гиацит", "Гипсофила", "Гортензия", "Ирис", "Калла", "Леукодендрон", "Лилия", "Орхидея Цимбидиум", "Пион", "Подсолнух", "Протея", "Ранункулюс", "Роза", "Роза Эквадор", "Роза Голландия", "Роза Кения", "Роза спрей", "Ромашка", "Хиперикум", "Тюльпан", "Фрезия", "Хелеборус", "Хлопок", "Хризантема", "Эрингиум", "Эустома"]
    let bouqets = ["Все", "Авторские", "Из роз", "Из 101 розы", "Классические", "Недорогие букеты", "Свадебные", "Фруктовые", "Эксклюзивные", "В форме сердца", "В боксах", "Со сладостями", "C Шампанским"]
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func filterTapped(_ sender: UIButton) {
        if filterSlidingConstraint.constant == 0 {
            filterSlidingConstraint.constant = filterTableView.bounds.width
            hideFilterButton.alpha = 0.6
        }else{
            filterSlidingConstraint.constant = 0
            hideFilterButton.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: - Private Implementation
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory: String?
    private var filterData = [filterCellData]()
    
    //MARK: View
    
    //MARK: Button
    @IBOutlet weak var hideFilterButton: UIButton!
    
    //MARK: TableView
    @IBOutlet private weak var catalogTableView: UITableView!
    @IBOutlet private weak var filterTableView: UITableView!
    
    //MARK: Constraint
    @IBOutlet private weak var filterSlidingConstraint: NSLayoutConstraint!
}









//MARK: - Extention:

//MARK: - by TableView
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == filterTableView {
            return filterData.count
        }else{
            return filterData.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == catalogTableView {
            return productInfo.count
        }else{
            if filterData[section].opened == true {
                let count = filterData[section].sectionData.count + 1
                return count
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == catalogTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.CatalogTVCell.rawValue, for: indexPath) as! CatalogTableViewCell,
            fetch = productInfo[indexPath.row],
            name = fetch.productName,
            price = fetch.productPrice,
            description = fetch.productDescription,
            category = fetch.productCategory,
            stock = fetch.stock
            
            cell.delegate = self
            cell.fill(name: name, price: price, description: description, category: category, stock: stock)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.FilterTVCell.rawValue, for: indexPath) as! FilterTableViewCell
            if indexPath.row == 0 {
                cell.textLabel?.text = filterData[indexPath.section].title
                cell.textLabel?.textColor = UIColor.pinkColorOfEnterprise
                cell.backgroundColor = UIColor.purpleColorOfEnterprise
                cell.textLabel?.font.withSize(24)
                return cell
            }else{
                let dataIndex = indexPath.row - 1
                cell.textLabel?.text = filterData[indexPath.section].sectionData[dataIndex]
                cell.textLabel?.textColor = UIColor.purpleColorOfEnterprise
                cell.backgroundColor = UIColor.pinkColorOfEnterprise
                cell.textLabel?.font.withSize(16)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.FilterTVCell.rawValue, for: indexPath) as! FilterTableViewCell
            if indexPath.row == 0  {
                filterData[indexPath.section].opened = !filterData[indexPath.section].opened
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
            }else{
                let dataIndex = indexPath.row - 1
                print(filterData[indexPath.section].sectionData[dataIndex])
            }
        }
    }
    
}

//MARK: - Filter categories
private extension CatalogViewController {
    
    // - appearance
    
    
    // - selected
    
}

//MARK: - by Table View Cell Delegate
extension CatalogViewController: CatalogTableViewCellDelegate {
    
    //MARK: Adding to user's Cart
    func addToCart(_ cell: CatalogTableViewCell) {
        
        let price = cell.price,
        image = cell.productImageView.image
        guard let name = cell.productNameLabel.text,
            let category = cell.category,
            let stock = cell.stock,
            let imageData: Data = image?.pngData() as Data? else {return}
        
        CoreDataManager.shared.addProduct(name: name, category: category, price: price, quantity: 1, stock: stock, imageData: imageData, success: {
            self.present(UIAlertController.completionDoneHalfSec(title: "Товар", message: "Добавлен"), animated: true)
            guard let cartItem = self.tabBarController?.tabBar.items?[0] else {return}
            CoreDataManager.shared.cartIsEmpty(bar: cartItem)
        }) {
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание!", message: "Произошла ошибка. Товар НЕ добавлен"), animated: true)
        }
    }
}




