//
//  Utils.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-25.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

struct CustomColors {
    static let red = UIColor(red: 235/255, green: 93/255, blue: 87/255, alpha: 1.0)
    static let blue = UIColor(red: 86/255, green: 184/255, blue: 248/255, alpha: 1.0)
    static let green = UIColor(red: 95/255, green: 206/255, blue: 140/255, alpha: 1.0)
    static let pink = UIColor(red: 230/255, green: 105/255, blue: 204/255, alpha: 1.0)
    static let purple = UIColor(red: 146/255, green: 104/255, blue: 245/255, alpha: 1.0)
    static let orange = UIColor(red: 255/255, green: 198/255, blue: 37/255, alpha: 1.0)
}

extension UIView {
    
    func setCornerRadius() {
        layer.cornerRadius = frame.height * 0.1
        clipsToBounds = true
    }
    
    func setStandardShadow() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        print("Corner radius is \(layer.cornerRadius)")
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

