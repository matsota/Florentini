//
//  DesignButton.swift
//  Florentini
//
//  Created by Andrew Matsota on 22.03.2020.
//  Copyright © 2020 Andrew Matsota. All rights reserved.
//

import UIKit

@IBDesignable
    class DesignButton: UIButton {
    
    @IBInspectable var rounding: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = rounding
        }
    }
   
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
           didSet {
               self.layer.borderWidth = borderWidth
           }
       }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            }
        }

    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
        }
    }

    @IBInspectable var shadowOffsetY_Axis: CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.height = shadowOffsetY_Axis
        }
    }
    @IBInspectable var shadowOffsetX_Axis: CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.width = shadowOffsetX_Axis
        }
    }
}

