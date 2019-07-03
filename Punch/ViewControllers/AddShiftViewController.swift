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
    @IBOutlet weak var headerContainerView: UIView!
    
    var dataSource: [[Any]] = [
        [Date()],
        [Date()],
        [
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false),
//            (employee: Employee(name: "Pat Trudel", amountOwed: 1600), isSelected: false)
//
        ],
        ["Save Button"]
    ]
    var selectedRowSection = -1 // only one selected cell allowed.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: CustomColors.orange, colorTwo: CustomColors.darkOrange)
        testLocationManager()
        setupDismissGesture()
    }
    
    override func viewDidLayoutSubviews() {
        setupTableView()
    }
    
    func testLocationManager() {
        LocationManager.shared.setupLocationManager()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: EmployeeTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: EmployeeTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: SaveShiftTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: SaveShiftTableViewCell.reuseIdentifier())
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        if self.dataSource[2].isEmpty {
            self.getEmployees()
        }
    }
    
    func setupDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissGesture(gesture:)))
        swipeGesture.direction = .down
        headerContainerView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleDismissGesture(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
            return "Employees"
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
            guard let (employee,isSeleted) = dataSource[indexPath.section][indexPath.row] as? (Employee1,Bool) else { return UITableViewCell() }
            let employeeCell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.reuseIdentifier()) as! EmployeeTableViewCell
            employeeCell.titleLabel.text = employee.name
            employeeCell.showCheckmark = isSeleted
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = CustomColors.darkBlue
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selectedRowSection,
            let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell {
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
            
            var tuple = dataSource[2][indexPath.row] as! (employee: Employee1, isSelected: Bool)
            tuple.isSelected = !tuple.isSelected
            dataSource[2][indexPath.row] = tuple
            selectedRowSection = -1 // Hide the date pickers if open.
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            // SAVE BUTTON
            submitShifts()
            let loadingView = LoadingView(frame: .zero)
            view.addSubview(loadingView)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                loadingView.complete()
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
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
            dataSource[1][0] = datePlus8Hours // Adjusts the end date in the data source when the user automagically sets it to the new date.
        }
    }
    
}

//MARK: FIREBASE CALLS.
extension AddShiftViewController {
    
    func getEmployees() {
        DataService.instance.getEmployeesByCompanyId(companyId: "FD69FCED-C156-469A-82C2-05A24D787B76") { (employees) in
            guard let employees = employees else { return }
            
            var employeesIsSelected = [(Employee1, Bool)]()
            employees.forEach({ (employee) in
                employeesIsSelected.append((employee, false))
            })
            self.dataSource[2] = employeesIsSelected
            self.tableView.reloadData()
        }
    }
    
    func submitShifts() {
        
        guard let startDate = dataSource[0].first as? Date else { return }
        guard let endDate = dataSource[1].first as? Date else { return }
        
        
        #warning("END DATE IS JUST SUBMITTING CURRENT TIME?")
        
        guard let employees = dataSource[2] as? [(Employee1,Bool)] else { return }
        
        for (employee,isSelected) in employees {
            if isSelected {
                #warning("REPLACE THIS WITH THE REAL (EMPLOYEE.ID) ONCE ITS SETUP.")
                let employeeID = employee.id
                DataService.instance.createDBShift(uid: UUID().uuidString, shiftData: [
                    "employeeId": "\(employeeID)",
                    "finishTime": "\(endDate.timeIntervalSince1970)",
                    "hourlyRate": employee.hourlyRate,
                    "punchInTime": "",
                    "punchOutTime": "",
                    "startTime": "\(startDate.timeIntervalSince1970)"
                    ])
                print("SUBMITTING SHIFT TO FIREBASE ✅")
            }
        }
    }
}
