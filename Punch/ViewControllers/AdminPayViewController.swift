//
//  AdminPayViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class AdminPayViewController: UIViewController {
    @IBOutlet weak var titleContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let items: [Employee] = [
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        Employee(name: "Pat Trudel", amountOwed: 1600),
        
    ]
    
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        titleContainerView.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
        titleContainerView.setStandardShadow()
    }
    
}

extension AdminPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.2)
    }
}

extension AdminPayViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = items[indexPath.item].name
        cell.detailLabel.text = "$\(items[indexPath.item].amountOwed)"
        cell.setStandardShadow()
        cell.setCornerRadius()
        cell.setStandardShadow()
        return cell
    }
    
    
    
}
