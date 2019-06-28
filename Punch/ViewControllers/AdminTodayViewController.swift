//
//  AdminViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class AdminTodayViewController: UIViewController {
    
    let items: [Employee] = [
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
    ]

}

extension AdminTodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.2)
    }
}

extension AdminTodayViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = items[indexPath.item].name
        cell.detailLabel.text = items[indexPath.item].shift.first!.start.description
        cell.setStandardShadow()
        cell.setCornerRadius()
        cell.setStandardShadow()
        return cell
    }
    
}

