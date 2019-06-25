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
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.cornerRadius = cell.frame.height * 0.2
        cell.layer.shadowColor = Int.random(in: 1...6) == 1 ? UIColor.red.cgColor : UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
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
