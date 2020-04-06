//
//  String + Custom.swift
//  Florentini
//
//  Created by Andrew Matsota on 06.04.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import Foundation


extension String {
    func countRegularCustomers(deviceID: String) -> Int{
        var deviceIDArray = [String]()
        let separateSymbols = "(), "
        for i in self.lowercased()
        .components(separatedBy: CharacterSet(charactersIn: separateSymbols))
            .filter({x in x != ""}) {
                deviceIDArray.append(i)
        }
        return deviceIDArray.filter{$0 == deviceID}.count
    }
}
