//
//  File.swift
//  Florentini
//
//  Created by Andrew Matsota on 23.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation

//MARK: - FAQViewController
protocol FAQMenuOptionsDelegate: class {
    func transitionSelector(_ class: UserFAQViewController)
}


//MARK: - AboutUsViewController
protocol AboutUsMenuOptionsDelegate: class {
    func transitionSelector(_ class: UserAboutUsViewController)
}
