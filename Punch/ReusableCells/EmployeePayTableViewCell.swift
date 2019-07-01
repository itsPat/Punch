//
//  EmployeePayTableViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-07-01.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class EmployeePayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var amountOwedLabel: UILabel!
    
    var initialSize: CGSize?
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "EmployeePayTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "EmployeePayTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius()
        selectedBackgroundView?.setCornerRadius()
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if initialSize == nil {
            initialSize = frame.size
            frame.size = CGSize(width: initialSize!.width, height: initialSize!.height - 16)
            return // Will make the next ! safe.
        }
        guard let initialSize = initialSize else { return }
        frame.size = CGSize(width: initialSize.width, height: initialSize.height - 16)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
