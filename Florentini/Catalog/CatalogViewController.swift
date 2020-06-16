//
//  CatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 19.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

struct filterTVStruct {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class CatalogViewController: UIViewController{
    
    //MARK: - Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.shared.createRefs()
        NetworkManager.shared.downloadProductsInfo(success: { productInfo in
            self.productInfo = productInfo.shuffled()
            self.catalogTableView.reloadData()
        }) { error in
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Скорее всего произошла потеря соединения"), animated: true)
            print("ERROR: CatalogViewController: viewWillAppear: downloadProductsInfo ", error.localizedDescription)
        }
        NetworkManager.shared.downloadFilteringDict(success: { (data) in
            self.filterData = [filterTVStruct(opened: false, title: NavigationCases.ProductCategories.flower.rawValue, sectionData: data.flower),
                               filterTVStruct(opened: false, title: NavigationCases.ProductCategories.bouquet.rawValue, sectionData: data.bouquet),
                               filterTVStruct(opened: false, title: NavigationCases.ProductCategories.gift.rawValue, sectionData: data.gift)]
            self.filterTableView.reloadData()
        }) { (error) in
            self.present(UIAlertController.completionDoneTwoSec(title: "Внимание", message: "Скорее всего произошла потеря соединения"), animated: true)
            print("ERROR: CatalogViewController: viewWillAppear: downloadFilteringDict ", error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: - TransitionMenu button Tapped
    @IBAction private func filterTapped(_ sender: UIButton) {
        filterSlidingConstraint.constant = hideUnhideFilter()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Private Implementation
    private var productInfo: [DatabaseManager.ProductInfo]?
    private var filteredProductInfoBySearchBar: [DatabaseManager.ProductInfo]?
    private var searchActivity = false
    private var filterData = [filterTVStruct]()
    private var selectedCategory: String?
    
    //MARK: Search Bar
    @IBOutlet private weak var mySearchBar: UISearchBar!
    
    
    //MARK: Button
    @IBOutlet private weak var hideFilterButton: UIButton!
    
    //MARK: TableView
    @IBOutlet private weak var catalogTableView: UITableView!
    @IBOutlet private weak var filterTableView: UITableView!
    
    //MARK: Constraint
    @IBOutlet private weak var filterSlidingConstraint: NSLayoutConstraint!
}









//MARK: - Extention:

//MARK: - Search Results
extension CatalogViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredProductInfoBySearchBar = productInfo?.filter({ (data) -> Bool in
                searchActivity = true
                return data.searchArray.contains { (string) -> Bool in
                    string.prefix(searchText.count).lowercased() == searchText.lowercased()
                }
            })
            self.catalogTableView.reloadData()
        }else{
            searchBar.placeholder = "Начните поиск"
            self.searchActivity = false
            self.catalogTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.placeholder = "Начните поиск"
        catalogTableView.reloadData()
    }
    
}

//MARK: - by TableView
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == filterTableView {
            return filterData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == catalogTableView {
            if searchActivity {
                return filteredProductInfoBySearchBar?.count ?? 0
            }
            return productInfo?.count ?? 0
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
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.CatalogTVCell.rawValue, for: indexPath) as! CatalogTableViewCell
            cell.delegate = self
            cell.tag = indexPath.row
            
            var fetch: DatabaseManager.ProductInfo?
            
            if searchActivity {
                fetch = self.filteredProductInfoBySearchBar?[cell.tag]
            }else{
                fetch = self.productInfo?[cell.tag]
            }
            guard let name = fetch?.productName,
                let price = fetch?.productPrice,
                let description = fetch?.productDescription,
                let category = fetch?.productCategory,
                let stock = fetch?.stock,
                let id = fetch?.productID else {return cell}
            
            
            cell.fill(id: id, name: name, price: price, description: description, category: category, stock: stock)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.FilterTVCell.rawValue, for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = filterData[indexPath.section].title
                cell.textLabel?.textColor = UIColor.pinkColorOfEnterprise
                cell.backgroundColor = UIColor.purpleColorOfEnterprise
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                return cell
            }else{
                let dataIndex = indexPath.row - 1
                cell.textLabel?.text = filterData[indexPath.section].sectionData[dataIndex]
                cell.textLabel?.textColor = UIColor.purpleColorOfEnterprise
                cell.backgroundColor = UIColor.pinkColorOfEnterprise
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterTableView {
            if indexPath.row == 0  {
                filterData[indexPath.section].opened = !filterData[indexPath.section].opened
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
            }else{
                let dataIndex = indexPath.row - 1,
                title = filterData[indexPath.section].title,
                subCategory = filterData[indexPath.section].sectionData[dataIndex]
                
                if subCategory == "Все"{
                    NetworkManager.shared.downloadByCategory(category: title, success: { data in
                        self.filterSlidingConstraint.constant = self.hideUnhideFilter()
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                            self.productInfo  = data
                            self.catalogTableView.reloadData()
                        }
                    }) { error in
                        self.present(UIAlertController.completionDoneTwoSec(title: "", message: ""), animated: true)
                        print("ERROR: CatalogViewController: tableView/didSelectRowAt: downloadByCategory", error.localizedDescription)
                    }
                }else{
                    NetworkManager.shared.downloadBySubCategory(category: title, subCategory: subCategory, success: { (data) in
                        self.filterSlidingConstraint.constant = self.hideUnhideFilter()
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                            self.productInfo = data
                            self.catalogTableView.reloadData()
                        }
                    }) { (error) in
                        self.present(UIAlertController.completionDoneTwoSec(title: "", message: ""), animated: true)
                        print("ERROR: CatalogViewController: didSelectRowAt: downloadBySubCategory: ", error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

//MARK: - by Table View Cell Delegate
extension CatalogViewController: CatalogTableViewCellDelegate {
    
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

//MARK: - Hide and show Any
private extension CatalogViewController {
    
    func hideUnhideFilter() -> CGFloat {
        var verticalContraint: CGFloat?
        if filterSlidingConstraint.constant == 0 {
            verticalContraint = filterTableView.bounds.width
            hideFilterButton.alpha = 0.6
        }else{
            verticalContraint = 0
            hideFilterButton.alpha = 0
        }
        return verticalContraint ?? 0
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
    }
}




