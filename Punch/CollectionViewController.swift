//
//  CollectionView.swift
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
}

class CollectionView: UIViewController {

    
    let items: [Employee] = [
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())]),
    ]
    
    

}

extension CollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.2)
    }
}

extension CollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = items[indexPath.item].name
        cell.detailLabel.text = items[indexPath.item].shift.first!.start.description
        cell.layer.backgroundColor = UIColor(red: 90/255, green: 103/255, blue: 247/255, alpha: 1.0).cgColor
        cell.layer.cornerRadius = cell.frame.height * 0.2
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
}
