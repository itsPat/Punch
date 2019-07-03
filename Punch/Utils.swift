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

public func calculateScoreFrom(shifts: [Shift1]) -> Double {
    var score: Double = 0
    
    for shift in shifts {
        var total: Double = 100
        guard let startTimeInterval = TimeInterval(shift.startTime) else { return 0.0 }
        let startDate = Date(timeIntervalSince1970: startTimeInterval)
        
        if let punchInTime = shift.punchInTime,
            let punchInTimeInterval = TimeInterval(punchInTime) {
                let punchInDate = Date(timeIntervalSince1970: punchInTimeInterval)
            if punchInTimeInterval > startTimeInterval {
                total -= 10
            }
            
            if punchInTimeInterval <= startTimeInterval && score != 100 {
                total += 10
            }
        }
        if Date().timeIntervalSince1970 >= startTimeInterval + 86400 && shift.punchInTime == "" {
            total -= 20
        }
        
        score += total

    }
    return score / Double(shifts.count) / 100
}

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
        layer.cornerRadius = frame.height * 0.2
        clipsToBounds = true
    }
    
    func setStandardShadow() {
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
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





    
    func greaterThanOrEqual(otherDate: Date) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-MM"
        return dateFormatter.calendar.compare(self, to: otherDate, toGranularity: .day).rawValue == 1 || dateFormatter.calendar.compare(self, to: otherDate, toGranularity: .day).rawValue == 0
    }

    func lessThanOrEqual(otherDate: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-MM"
        return dateFormatter.calendar.compare(self, to: otherDate, toGranularity: .day).rawValue == -1 || dateFormatter.calendar.compare(self, to: otherDate, toGranularity: .day).rawValue == 0

    }

    func from(_ string: String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-MM hh:mm a"
        return dateFormatter.date(from: string)
    }

    func string() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-MM hh:mm a"
        return dateFormatter.string(from: self)
    }

}
