//
//  CustomCollectionReusableView.swift
//  Punch
//
//  Created by Russell Weber on 2019-06-27.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
    
    var calendar = FSCalendar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    func customInit() {
        calendar.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.9, height: self.frame.height * 0.9)
        calendar.center = self.center
        self.addSubview(calendar)
        setupCalendarView()
    }
    
    func setupCalendarView() {
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 12)
        calendar.backgroundColor = UIColor.clear
        //            calendar.layer.cornerRadius = calendar.frame.width * 0.05
        //            calendar.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
        //            calendar.setStandardShadow()
    }
}
