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
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.imageView.image = UIImage(named: "beforePunchIn")
    }
    
    public func configure(with model: Shift1) {
        
        guard let startTimeInterval = TimeInterval(model.startTime) else { return }
        guard let finishTimeInterval = TimeInterval(model.finishTime) else { return }
        let startTime = Date(timeIntervalSince1970: startTimeInterval)
        let finishTime = Date(timeIntervalSince1970: finishTimeInterval )
        let dayTextLabel = formatToDateString(date: startTime)
        let timeLabelText = (formatToHourMinutesString(date: Date(timeIntervalSince1970: TimeInterval(model.punchInTime ?? model.startTime) ?? startTimeInterval)) + " - " + formatToHourMinutesString(date: Date(timeIntervalSince1970: TimeInterval(model.punchOutTime ?? model.finishTime) ?? finishTimeInterval)))
        dayLabel.text = dayTextLabel
        timeLabel.text = timeLabelText
        let punchInTimeInterval = TimeInterval(model.punchInTime ?? "")
        //        let punchInDate = Date(timeIntervalSince1970: punchInTimeInterval)
        
        if model.punchInTime == "" && Date().timeIntervalSince1970 <= startTimeInterval {
            print("before punch in for punchInTime \(model.punchInTime), for date \(Date())")
            imageView.image = UIImage(named: "beforePunchIn")
        }
        if model.punchInTime == "" && Date().timeIntervalSince1970 > startTimeInterval {
            print("after punch in for punchInTime \(model.punchInTime), for date \(Date())")
            imageView.image = UIImage(named: "alertPunchIn")
        }
        if let timeInterval = punchInTimeInterval{
            if timeInterval <= startTimeInterval + 120 {
                imageView.image = UIImage(named: "goodPunchedIn")
            }
            if let timeInterval = punchInTimeInterval{
                if timeInterval > startTimeInterval + 120 {
                    imageView.image = UIImage(named: "alertPunchedIn")
                }
            }
        }
    }
    
    public func configure(with model: Shift1, and employeeName: String) {
        guard let startTimeInterval = TimeInterval(model.startTime) else { return }
        guard let finishTimeInterval = TimeInterval(model.finishTime) else { return }
        let startTime = Date(timeIntervalSince1970: startTimeInterval)
        
        let timeLabelText = (formatToHourMinutesString(date: Date(timeIntervalSince1970: TimeInterval(model.punchInTime ?? model.startTime) ?? startTimeInterval)) + " - " + formatToHourMinutesString(date: Date(timeIntervalSince1970: TimeInterval(model.punchOutTime ?? model.finishTime) ?? finishTimeInterval)))
        dayLabel.text = employeeName
        timeLabel.text = timeLabelText
        let punchInTimeInterval = TimeInterval(model.punchInTime ?? "")
        if model.punchInTime == "" && Date().timeIntervalSince1970 <= startTimeInterval {
            print("before punch in for punchInTime \(model.punchInTime), for date \(Date())")
            imageView.image = UIImage(named: "beforePunchIn")
        }
        if model.punchInTime == "" && Date().timeIntervalSince1970 > startTimeInterval {
            print("after punch in for punchInTime \(model.punchInTime), for date \(Date())")
            imageView.image = UIImage(named: "alertPunchIn")
        }
        if let timeInterval = punchInTimeInterval{
            if timeInterval <= startTimeInterval + 120 {
                imageView.image = UIImage(named: "goodPunchedIn")
            }
            if let timeInterval = punchInTimeInterval{
                if timeInterval > startTimeInterval + 120 {
                    imageView.image = UIImage(named: "alertPunchedIn")
                }
            }
        }
    }
}
