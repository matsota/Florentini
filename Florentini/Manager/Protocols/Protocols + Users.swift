//
//  UsersVCs + Protocol.swift
//  Florentini
//
//  Created by Andrew Matsota on 24.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

//MARK: COMMON PROTOCOLS:

//MARK: - Для подготовки к переходу между ViewController'ами
protocol PrepareForUserSIMTransitionDelegate: class {

    func showSlideInMethod(_ sender: UIButton)
    
}

//MARK: - Для Перехода между ViewController'ами

protocol UserSlideInMenuTransitionDelegate: class {
    
    func transitionMethod(_ class: UIViewController, _ menuType: UserSlidingMenuVC.MenuType)
    
}

//MARK: - Для появления всех кнопочных вариантов на выбор
protocol PrepareForSelectionMethodDelegate: class {

    func showOptionsMethod(option: String)
    
}

//MARK: - Для выбора кнопочного варианта
protocol SelectionByButtonCollectionDelegate: class {
    
    func selectionMethod (_ class: UIViewController, _ sender: UIButton)
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////



//MARK: PERSONAL PROTOCOLS:

//MARK: - Basket
//MARK: Basket-TableViewCell
protocol UserBasketTableViewCellDelegate: class {
    
    func sliderValue(_ cell: UserBasketTableViewCell)
    
}

//MARK: - Catalog

//MARK: User-Catalog-TableViewCell
protocol UserCatalogTableViewCellDelegate: class {
    
    func addToCart(_ cell: UserCatalogTableViewCell)
    
}


