//
//  MemeCell.swift
//  MemeIQ
//
//  Created by Michael Rojas on 7/8/18.
//  Copyright © 2018 Michael Rojas. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: Shift1) {
        guard let startTimeInterval = TimeInterval(model.startTime) else { return }
        guard let finishTimeInterval = TimeInterval(model.startTime) else { return }
        let startTime = Date(timeIntervalSince1970: startTimeInterval)
        let finishTime = Date(timeIntervalSince1970: finishTimeInterval )
        let dayTextLabel = formatToDateString(date: startTime)
        let timeLabelText = (formatToHourMinutesString(date: startTime) + " - " + formatToHourMinutesString(date: finishTime))
        dayLabel.text = dayTextLabel
        timeLabel.text = timeLabelText
        print(Date())
    }
    
    public func configure(with employee: Employee1) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        let hrlyRate = employee.hourlyRate
        if let formattedHrlyRate = formatter.string(from: hrlyRate as NSNumber) {
            timeLabel.text = "Hourly Rate: \(formattedHrlyRate)"
        }
        dayLabel.text = employee.name
    }
    
}
