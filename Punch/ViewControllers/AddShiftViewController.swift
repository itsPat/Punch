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
    
    var dataSource: [[Any]] = [
        [Date()],
        [Date()],
        [
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
            Employee(name: "Pat Trudel", shift: [Shift(start: Date(), finish: Date())], amountOwed: 1600),
        ],
        ["Save Button"]
    ]
    var selectedRowSection = -1 // only one selected cell allowed.

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.setGradientBackground(colorOne: CustomColors.orange, colorTwo: CustomColors.darkOrange)
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: EmployeeTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: EmployeeTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: SaveShiftTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: SaveShiftTableViewCell.reuseIdentifier())
        tableView.showsVerticalScrollIndicator = false
    }

}

// MARK: UITABLEVIEW DATASOURCE

extension AddShiftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Start Date"
        case 1:
            return "End Date"
        case 2:
            return "Employee"
        case 3:
            return "Save Shift"
        default:
            break
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? dataSource[2].count : 1 // Only need 1 row except for employees section.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0,1:
            guard let date = dataSource[indexPath.section][indexPath.row] as? Date else { return UITableViewCell() }
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier:   DatePickerTableViewCell.reuseIdentifier()) as!  DatePickerTableViewCell
            datePickerCell.delegate = self
            datePickerCell.indexPath = indexPath
            datePickerCell.updateText(date: date)
            return datePickerCell
        case 2:
            guard let employee = dataSource[indexPath.section][indexPath.row] as? Employee else { return UITableViewCell() }
            let employeeCell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier()) as! EmployeeTableViewCell
            employeeCell.titleLabel.text = employee.name
            return employeeCell
        case 3:
            let saveButtonCell = tableView.dequeueReusableCell(withIdentifier: SaveShiftTableViewCell.reuseIdentifier()) as! SaveShiftTableViewCell
            return saveButtonCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    
}

// MARK: UITABLEVIEW DELEGATE

extension AddShiftViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selectedRowSection {
            // Index path must be less than 2 to cast as DatePickerTableViewCell
            let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
            if !cell.isOpen {
                cell.toggleCalendar(active: true)
            }
            return 280
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell {
            if cell.isOpen {
                cell.toggleCalendar(active: false)
            }
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0,1:
            // DATE PICKERS
            if selectedRowSection != indexPath.section {
                selectedRowSection = indexPath.section
                
            } else {
                selectedRowSection = -1
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        case 2:
            // EMPLOYEES
            if let cell = tableView.cellForRow(at: indexPath) as? EmployeeTableViewCell {
                cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
                selectedRowSection = -1 // Hide the date pickers if open.
            }
        default:
            // SAVE BUTTON
            print("Save button tapped.")
            break // Button to save dismiss vc and
        }
        
    }
}

//MARK: DATE PICKER DELEGATE.
extension AddShiftViewController: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        dataSource[indexPath.section][indexPath.row] = date
        let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
        cell.updateText(date: date)
        if indexPath.section == 0 {
            // If they set the start date, we automagically set the end date to 8 hours later.
            guard let datePlus8Hours = Calendar.current.date(byAdding: .hour, value: 8, to: date) else { return }
            guard let endDateCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section + 1)) as? DatePickerTableViewCell else { return }
            endDateCell.updateText(date: datePlus8Hours)
            print("SUBMITTING DATE OBJECT ✅ \n \(date.timeIntervalSince1970) SUBMITTED DATE OBJECT ✅ \n ")
        }
    }
    
}

//MARK: FIREBASE CALLS.
extension AddShiftViewController {
    func submitShifts() {
        // Check all the selected employee cells, make a shift object for each of those employees with the same date object.
//        DataService.instance.createDBShift(uid: UUID().uuidString, shiftData: [<#T##Dictionary<String, Any>#>])
    }
}
