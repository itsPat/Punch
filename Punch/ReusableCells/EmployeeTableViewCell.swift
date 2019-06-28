//
//  EmployeeTableViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-28.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "EmployeeTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "EmployeeTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius()
        selectedBackgroundView?.setCornerRadius()
        clipsToBounds = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
