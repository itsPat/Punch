//
//  Utils.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-25.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

struct CustomColors {
    static let blue = UIColor(red: 91/255, green: 109/255, blue: 248/255, alpha: 1.0)
    static let darkBlue = UIColor(red: 98/255, green: 70/255, blue: 225/255, alpha: 1.0)
    static let orange = UIColor(red: 253/255, green: 211/255, blue: 48/255, alpha: 1.0)
    static let darkOrange = UIColor(red: 252/255, green: 177/255, blue: 44/255, alpha: 1.0)
    static let gray = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
}

//MARK: - Helper Methods

public func formatToDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM dd"
    return dateFormatter.string(from: date)
}

public func formatToHourMinutesString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: date)
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
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension Date {
    
    enum DateFormatType: String {
        /// Date with hours
        case dateWithTime = "dd-MMM-yyyy  H:mm"
    }
    
    func convertToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        return newDate
    }
    
}
