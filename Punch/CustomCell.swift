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
    
    public func configure(with model: Shift) {
        dayLabel.text = "\(model.finish)"
        timeLabel.text = model.start.description
    }
    
}
