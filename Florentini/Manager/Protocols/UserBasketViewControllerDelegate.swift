//
//  UserBasketViewControllerDelegate.swift
//  Florentini
//
//  Created by Andrew Matsota on 23.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

protocol UserBasketViewControllerDelegate: class {
    func choosingFeedbackOption (_ class: UserBasketViewController, _ sender: DesignButton)
}
