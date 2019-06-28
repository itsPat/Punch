//
//  DatePickerTableViewCell.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//


import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var indexPath: IndexPath!
    weak var delegate: DatePickerDelegate?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DatePickerTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DatePickerTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        heightConstraint.constant = 0
        setStandardShadow()
        setCornerRadius()
        selectedBackgroundView?.setCornerRadius()
        datePicker.setDate(Date(), animated: true)
    }
    
    func toggleCalendar(active: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            if active {
                self.heightConstraint.constant = 190
            } else {
                self.heightConstraint.constant = 0
            }
        }, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initView() {
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }

    func updateCell(date: Date, indexPath: IndexPath) {
        datePicker.setDate(date, animated: true)
        self.indexPath = indexPath
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        let indexPathForDisplayDate = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        delegate?.didChangeDate(date: sender.date, indexPath: indexPathForDisplayDate)
    }
    
    func updateText(text: String, date: Date) {
        label.text = text
        dateLabel.text = date.convertToString(dateformat: .dateWithTime)
    }

}
