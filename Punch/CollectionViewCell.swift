//
//  CollectionViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var textLabel = UILabel()
    var subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        subtitleLabel = UILabel(frame: CGRect(x: 0, y: self.center.y * 2, width: self.frame.width, height: self.frame.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
