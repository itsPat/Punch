//
//  DateTableViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//


import UIKit

/// Date Format type
enum DateFormatType: String {
    /// Date with hours
    case dateWithTime = "dd-MMM-yyyy  H:mm"
}

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DateTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DateTableViewCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 80.0
    }

    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Update text
    func updateText(text: String, date: Date) {
        label.text = text
        dateLabel.text = date.convertToString(dateformat: .dateWithTime)
    }

}

extension Date {
    
    func convertToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        return newDate
    }
    
}
