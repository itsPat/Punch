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
    
    override func viewDidLoad() {
        collectionView.register(CalendarView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarView")
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.8)
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
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = cell.frame.height * 0.2
        cell.layer.shadowColor = Int.random(in: 1...6) == 1 ? UIColor.red.cgColor : UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "calendarView", for: indexPath) as! CalendarView
        headerView.dataSource = self
        headerView.delegate = self
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

extension EmployeeViewController: CalendarViewDataSource, CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
        
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date : Date) {
        
    }
    
    
//    func calendar(_ calendar: CalendarView, didLongPressDate date : Date) {
//        
//        let alert = UIAlertController(title: "Create New Event", message: "Message", preferredStyle: .alert)
//        
//        alert.addTextField { (textField: UITextField) in
//            textField.placeholder = "Event Title"
//        }
//        
//        let addEventAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
//            let title = alert.textFields?.first?.text
//            self.calendarView.addEvent(title!, date: date)
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//        
//        alert.addAction(addEventAction)
//        alert.addAction(cancelAction)
//        
//        self.present(alert, animated: true, completion: nil)
//        
//    }
    

    func startDate() -> Date {
        var dateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        dateComponents.year = -1
        let oneYearAgo = Calendar.current.date(from: dateComponents)!
        return oneYearAgo
    }

    func endDate() -> Date {
        var dateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        dateComponents.year = 1
        let oneYearFromToday = Calendar.current.date(from: dateComponents)!
        return oneYearFromToday
    }
}
