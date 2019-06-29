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
        let startTime = model.startTime
        let finishTime = model.finishTime
        dayLabel.text = finishTime
        timeLabel.text = startTime + " - " + finishTime
        print(Date())
    }
    
    public func configure(with employee: Employee1) {
        let hrlyRate = employee.hourlyRate
        dayLabel.text = employee.name
        timeLabel.text = "\(hrlyRate)"
    }
    
}
