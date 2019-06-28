//
//  InterfaceViewController.swift
//  Punch
//
//  Created by Russell Weber on 2019-06-28.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class InterfaceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1) // reduces screen tearing on iPhone X
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
}
