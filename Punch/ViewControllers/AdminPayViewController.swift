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
    @IBOutlet weak var allEmployeesPaidLabel: UILabel!
    
    
    var dataSource: [Employee1] = []
    
    
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
        if dataSource.isEmpty {
            populateDataSource()
        }
    }

    func populateDataSource() {
        print("Getting DATA ✅")
        DataService.instance.getEmployeesByCompanyId(companyId: "FD69FCED-C156-469A-82C2-05A24D787B76") { (employees) in
            guard let employees = employees else { return }
            print("EMPLOYEES FOR COMPANY ID 'FD69FCED-C156-469A-82C2-05A24D787B76' \n \(employees)")
            self.dataSource += employees.filter({ (employee) -> Bool in
                employee.amountOwed > 0
            }).sorted(by: { (employeeA, employeeB) -> Bool in
                return employeeA.amountOwed > employeeB.amountOwed
            })
            self.tableView.reloadData()
        }
    }
    
}

// MARK: UITABLEVIEW DATASOURCE

extension AdminPayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            allEmployeesPaidLabel.alpha = 1.0
        } else {
            allEmployeesPaidLabel.alpha = 0.0
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employeeCell = tableView.dequeueReusableCell(withIdentifier:   EmployeePayTableViewCell.reuseIdentifier()) as!  EmployeePayTableViewCell
        let employee = dataSource[indexPath.row]
        employeeCell.employeeNameLabel.text = employee.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        guard let formattedAmountOwed = formatter.string(from: employee.amountOwed as NSNumber) else { return UITableViewCell()}
        employeeCell.amountOwedLabel.text = formattedAmountOwed
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
        let employee = dataSource.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        DispatchQueue.global(qos: .background).async {
            DataService.instance.changeValueOfAmountOwedWith(EmployeeId: employee.id, value: 0.0)
        }
    }
}
