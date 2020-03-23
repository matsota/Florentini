//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 23.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

//MARK: - BasketTableViewCell
protocol BasketTableViewCellDelegate: class {
    func sliderValue(_ cell: BasketTableViewCell)
}

//MARK: - UserCatalogTableViewCell
protocol UserCatalogTableViewCellDelegate: class {
    func addToCart(_ cell: UserCatalogTableViewCell)
}
