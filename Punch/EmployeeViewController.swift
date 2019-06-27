//
//  EmployeeViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: - State
private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

struct Shift {
    let start: Date
    let finish: Date
}

struct Employee {
    let name: String
    let shift: [Shift]
    let amountOwed: Int
}

class EmployeeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarContainerView: UIView!
    
    var headerView: CustomCollectionReusableView!
    
    var calendarSize = CGSize()
    
    
    override func viewDidLoad() {
        calendarSize = CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.8)
        collectionView.register(CustomCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarView")
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //        calendarContainerView.setStandardShadow()
        //        calendarContainerView.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
    }
    
//    func setupCalendarView() {
//        headerView.calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
//        headerView.calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 12)
//        headerView.calendar.backgroundColor = UIColor.clear
//        //            calendar.layer.cornerRadius = calendar.frame.width * 0.05
//        //            calendar.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
//        //            calendar.setStandardShadow()
//    }
    
    let items: [Shift] = [
        
        //        [
        //            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600)
        //        ],
        
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
        Shift(start: Date(), finish: Date()),
    ]
    
    //TODO: When a cell is tapped, check that the date is today, if so punch the user in.
    
    
    
}

extension EmployeeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return calendarSize
    }
}

extension EmployeeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        var titleLabelText = ""
        var detailLabelText = ""
        
        //        if indexPath.section == 0 {
        //            // The $ Amount owed for this employee.
        //            let item = items[indexPath.section][indexPath.row] as! Employee
        //            titleLabelText = "$\(item.amountOwed)"
        //            detailLabelText = "80 hours worked"
        //        } else {
        // The Upcoming shifts for this employee.
        let item = items[indexPath.row]
        titleLabelText = formatToDateString(date: item.start)
        detailLabelText = "\(formatToHourMinutesString(date: item.start)) - \(formatToHourMinutesString(date: item.finish))"
        
        
        cell.titleLabel.text = titleLabelText
        cell.detailLabel.text = detailLabelText
        cell.setCornerRadius()
        cell.setStandardShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarView", for: indexPath) as! CustomCollectionReusableView
        headerView.calendar.dataSource = self
        headerView.calendar.delegate = self
        return headerView
    }
    
    func formatToDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: date)
    }
    
    func formatToHourMinutesString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
    }
    
}

extension EmployeeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
}
