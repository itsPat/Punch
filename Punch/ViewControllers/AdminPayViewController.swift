//
//  AdminPayViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class AdminPayViewController: UIViewController {
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var items: [Employee] = [
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
    }
    
    override func viewDidLayoutSubviews() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: EmployeePayTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: EmployeePayTableViewCell.reuseIdentifier())
        tableView.showsVerticalScrollIndicator = false
    }

    
}

// MARK: UITABLEVIEW DATASOURCE

extension AdminPayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employeeCell = tableView.dequeueReusableCell(withIdentifier:   EmployeePayTableViewCell.reuseIdentifier()) as!  EmployeePayTableViewCell
        let employee = items[indexPath.row]
        employeeCell.employeeNameLabel.text = employee.name
        employeeCell.amountOwedLabel.text = "$\(employee.amountOwed)"
        return employeeCell
    }
}

// MARK: UITABLEVIEW DELEGATE

extension AdminPayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        self.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
