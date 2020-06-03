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

class CatalogViewController: UIViewController {
    
    //MARK: - Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoad()
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
        setupSearchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
    private var selectedCategory: String?
    private var filterData = [filterTVStruct]()
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredProductsBySearchController: [DatabaseManager.ProductInfo]?
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    //MARK: Button
    @IBOutlet weak var hideFilterButton: UIButton!
    
    //MARK: TableView
    @IBOutlet private weak var catalogTableView: UITableView!
    @IBOutlet private weak var filterTableView: UITableView!
    
    //MARK: Constraint
    @IBOutlet private weak var filterSlidingConstraint: NSLayoutConstraint!
}









//MARK: - Extention:

//MARK: - Search Results
extension CatalogViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(search: searchController.searchBar.text!)
    }
    
    private func filterContentForSearch(search text: String) {
        filteredProductsBySearchController = productInfo?.filter({ (data: DatabaseManager.ProductInfo) -> Bool in
            return data.searchArray.contains { (string) -> Bool in
                string.lowercased().contains(text.lowercased())
            }
        })
        catalogTableView.reloadData()
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        let searchBar = searchController.searchBar
        catalogTableView.tableHeaderView = searchBar
        
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
            if isFiltering {
                return filteredProductsBySearchController?.count ?? 0
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
            cell.tag = indexPath.row
            var fetch: DatabaseManager.ProductInfo?
            
            if isFiltering {
                fetch = self.filteredProductsBySearchController?[cell.tag]
            }else{
                fetch = self.productInfo?[cell.tag]
            }
            guard let name = fetch?.productName,
                let price = fetch?.productPrice,
                let description = fetch?.productDescription,
                let category = fetch?.productCategory,
                let stock = fetch?.stock else {return cell}
            
            cell.delegate = self
            cell.fill(name: name, price: price, description: description, category: category, stock: stock)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.Transition.FilterTVCell.rawValue, for: indexPath) as! FilterTableViewCell
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
                sectionData = filterData[indexPath.section].sectionData[dataIndex]
                
                if sectionData == "Все"{
                    NetworkManager.shared.downloadByCategory(category: title, success: { productInfo in
                        self.filterSlidingConstraint.constant = self.hideUnhideFilter()
                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                            self.productInfo  = productInfo
                            self.catalogTableView.reloadData()
                        }
                    }) { error in
                        self.present(UIAlertController.completionDoneTwoSec(title: "", message: ""), animated: true)
                        print("ERROR: CatalogViewController: tableView/didSelectRowAt: downloadByCategory", error.localizedDescription)
                    }
                }else{
                    print(title, sectionData)
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
    
    func hideUnhideFilter() ->CGFloat {
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
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        //        lowestConstraint.constant = keyboardFrameValue.cgRectValue.height
        
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        setupSearchBar()
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
}




