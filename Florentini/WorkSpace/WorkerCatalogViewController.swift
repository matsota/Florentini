//
//  WorkerCatalogViewController.swift
//  Florentini
//
//  Created by Andrew Matsota on 21.02.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit
import FirebaseUI

class WorkerCatalogViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //data Implementation
        NetworkManager.shared.downloadProducts(success: { productInfo in
            self.productInfo = productInfo
            self.tableView.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - Menu button
    @IBAction func workerMenuTapped(_ sender: UIButton) {
        showWorkerSlideInMethod()
    }
    
    
    //MARK: - Chat Transition
    @IBAction func chatTapped(_ sender: UIButton) {
        transitionToWorkerChat()
    }
    
    //MARK: - Фильтр
    @IBAction func startFiltering(_ sender: DesignButton) {
        guard let sender = sender.titleLabel!.text else {return}
        showOptionsMethod(option: sender)
    }
    @IBAction func endFiltering(_ sender: DesignButton) {
        selectionMethod(self, sender)
    }
    
    
    
    
    
    //MARK: - Private:
    
    //MARK: - Methods
    
    //MARK: - Implementation
    private let slidingMenu = SlideInTransitionMenu()
    private let alert = UIAlertController()
    private var productInfo = [DatabaseManager.ProductInfo]()
    private var selectedCategory = String()
    
    //MARK: - View
    @IBOutlet weak var buttonsView: UIView!
    
    
    //MARK: - TableView Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Button
    @IBOutlet var allFilterButtonsCollection: [DesignButton]!
    @IBOutlet weak var filterButton: DesignButton!
    
}








//MARK: - Extention:

//MARK: - TableView Extention
extension WorkerCatalogViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerCatalogTVCell.rawValue, for: indexPath) as! WorkerCatalogTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        let get = productInfo[cell.tag],
        storageRef = Storage.storage().reference(withPath: "\(DatabaseManager.ProductCases.imageCollection.rawValue)/\(get.productName)")
        
        cell.fill(name: get.productName, price: get.productPrice, category: get.productCategory, description: get.productDescription, stock: get.stock) { image in
            image.sd_setImage(with: storageRef)
        }
        return cell
    }
    
    //deleteProduct
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NavigationCases.IDVC.WorkerCatalogTVCell.rawValue, for: indexPath) as! WorkerCatalogTableViewCell
        guard let name = cell.productNameLabel.text else {return nil}
        let delete = deleteAction(name: name, at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(name: String, at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, complition) in
            if AuthenticationManager.shared.currentUser?.uid == AuthenticationManager.shared.uidAdmin {
                self.present(self.alert.alertDeleteProduct(name: name, success: {
                    self.productInfo.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }), animated: true)
                complition(true)
            }else{
                self.present(self.alert.alertClassicInfoOK(title: "Эттеншн", message: "У Вас нет прав Администратора, чтобы удалять любую из позиций. Не ну ты ЧО"), animated: true)
                complition(false)
            }
        }
        action.backgroundColor = .red
        return action
    }
    
}

//MARK: Методы TableViewCell через delegate
extension WorkerCatalogViewController: WorkerCatalogTableViewCellDelegate {
    
    func editPrice(_ cell: WorkerCatalogTableViewCell){
        guard let name = cell.productNameLabel.text, let description = cell.productDescriptionLabel.text else {return}
        let category = cell.category,
        stock = cell.stock
        
        if AuthenticationManager.shared.uidAdmin == AuthenticationManager.shared.currentUser?.uid {
            cell.productPriceButton.isUserInteractionEnabled = true
            
            self.present(self.alert.alertEditProductPrice(name: name, category: category, description: description, stock: stock, success: { newPrice in
                cell.productPriceButton.setTitle("\(newPrice) грн", for: .normal)
            }),animated: true)
        }else{
            cell.productPriceButton.isUserInteractionEnabled = false
        }
        self.tableView.reloadData()
    }
    
    func editStockCondition(_ cell: WorkerCatalogTableViewCell) {
        
        guard let name = cell.productNameLabel.text, let description = cell.productDescriptionLabel.text else {return}
        let category = cell.category,
        price = cell.price
        
        if cell.stockSwitch.isOn == true {
            DispatchQueue.main.async {
                self.present(self.alert.alertEditStock(name: name, price: price, category: category, description: description, stock: true){
                    cell.stock = true
                    cell.stockConditionLabel.text = "Акционный товар"
                    cell.stockConditionLabel.textColor = .red
                }, animated: true)
                
            }
            
        }else{
            DispatchQueue.main.async {
                self.present(self.alert.alertEditStock(name: name, price: price, category: category, description: description, stock: false){
                    cell.stock = false
                    cell.stockConditionLabel.text = "Акция отсутствует"
                    cell.stockConditionLabel.textColor = .black
                }, animated: true)
            }
        }
    }
    
}

//MARK: - UIVC-TransitioningDelegate
extension WorkerCatalogViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        slidingMenu.isPresented = true
        return slidingMenu
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slidingMenu.isPresented = false
        return slidingMenu
    }
    
}

//MARK: - Появление вариантов Категорий для отфильтровывания продукции
private extension WorkerCatalogViewController {
    func showOptionsMethod(option: String) {
        selectedCategory = option
        allFilterButtonsCollection.forEach { (buttons) in
            if buttons.isHidden == true {
                UIView.animate(withDuration: 0.2) {
                    buttons.isHidden = false
                    self.filterButton.isHidden = !self.buttonsView.isHidden
                    self.buttonsView.layoutIfNeeded()
                }
            }else{
                UIView.animate(withDuration: 0.2) {
                    buttons.isHidden = true
                    self.buttonsView.layoutIfNeeded()
                }
            }
            filterButton.setTitle(option, for: .normal)
        }
    }
}

//MARK: - Метод фильтрации продукции по категориям
private extension WorkerCatalogViewController {
    
    func selectionMethod(_ class: UIViewController, _ sender: UIButton) {
        guard let title = sender.currentTitle, let categories = DatabaseManager.ProductCategoriesCases(rawValue: title) else {return}
        switch categories {
        case .apiece:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.apiece.rawValue)
            NetworkManager.shared.downloadApieces(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .gift:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.gift.rawValue)
            NetworkManager.shared.downloadGifts(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .bouquet:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.bouquet.rawValue)
            NetworkManager.shared.downloadBouquets(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .stock:
            showOptionsMethod(option: DatabaseManager.ProductCategoriesCases.stock.rawValue)
            NetworkManager.shared.downloadStocks(success: { productInfo in
                self.productInfo = productInfo
                self.filterButton.isHidden = false
                self.tableView.reloadData()
            }) { error in
                print(error.localizedDescription)
            }
        case .none:
            break
        }
    }
    
}

