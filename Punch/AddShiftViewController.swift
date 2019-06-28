//
//  AddShiftViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-27.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class AddShiftViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var datePickerIndexPath: IndexPath?
    
    var dataSource: [[(String, Any)]] = [
        [(title: "Start Date", date: Date())],
        [(title: "End Date", date: Date())],
//        [(title: "Start Date", employees: [Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600)])]
        
    ]
    
    var inputTexts: [String] = ["Start Date", "End date"]
    var inputDates: [Date] = []
    var selectedRowIndex = -1
    var cellIsSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addInitailValues()
        view.setGradientBackground(colorOne: CustomColors.orange, colorTwo: CustomColors.darkOrange)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
    }
    
    func addInitailValues() {
        inputDates = Array(repeating: Date(), count: inputTexts.count)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }

}

// MARK: UITABLEVIEW DATASOURCE

extension AddShiftViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? dataSource[section].count : 1 // Only need 1 row except for employees section.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datePickerCell = tableView.dequeueReusableCell(withIdentifier:   DatePickerTableViewCell.reuseIdentifier()) as!  DatePickerTableViewCell
        datePickerCell.delegate = self
        datePickerCell.updateText(text: dataSource[indexPath.section][indexPath.row].0, date: dataSource[indexPath.section][indexPath.row].1 as! Date)
        return datePickerCell
    }
    
    
}

// MARK: UITABLEVIEW DELEGATE

extension AddShiftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
            cell.toggleCalendar(active: true)
            cell.indexPath = indexPath
            return 280
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell {
            cell.toggleCalendar(active: false)
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedRowIndex != indexPath.row {
            self.cellIsSelected = true
            self.selectedRowIndex = indexPath.row
            
        } else {
            self.cellIsSelected = false
            self.selectedRowIndex = -1
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension AddShiftViewController: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        inputDates[selectedRowIndex] = date
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
