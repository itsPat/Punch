//
//  EmployeeViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var amountOwedLabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    var calendarSize = CGSize()
    
    override func viewDidLoad() {
        calendarSize = CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.8)
        collectionView.register(FSCalendar.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarView")
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        labelContainerView.setStandardShadow()
        labelContainerView.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
        setupCalendarView()
    }
    
    func setupCalendarView() {
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 12)
    }

    
    let items: [Shift] = [
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
}

extension EmployeeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = formatToDateString(date: items[indexPath.item].start)
        cell.detailLabel.text = "\(formatToHourMinutesString(date: items[indexPath.item].start)) - \(formatToHourMinutesString(date: items[indexPath.item].finish))"
        cell.setStandardShadow()
        cell.setCornerRadius()
        cell.setStandardShadow()
        return cell
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
        self.calendarSize = bounds.size
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
}
