//
//  EmployeeViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import CoreLocation

//MARK: - Structs

struct Shift {
    let start: Date
    let finish: Date
}

struct Employee {
    let name: String
    let amountOwed: Int
}

class EmployeeViewController: InterfaceViewController {
    //MARK: - Outlets
    @IBOutlet weak var calendarBottomConstraintView: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scoreAmountLabel: UILabel!
    
    // MARK: - vars
    
    var items: [Shift1] = []
    
    var user: Employee1!
    var company: Company!
    
    let shiftManager = ShiftManager()
    
    // MARK: - Views
    private lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.backgroundColor = UIColor.clear
        calendarView.appearance.headerTitleColor = CustomColors.orange
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 24)
        calendarView.appearance.titleDefaultColor = UIColor.white
        calendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 16)
        calendarView.appearance.titleTodayColor = UIColor.white
        calendarView.appearance.selectionColor = UIColor.white
        calendarView.appearance.titleSelectionColor = CustomColors.blue
        calendarView.appearance.todayColor = UIColor.orange
        calendarView.appearance.weekdayTextColor = UIColor.white
        calendarView.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16)
        
        return calendarView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var momentumView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.3, alpha: 1)
        view.topColor = UIColor.groupTableViewBackground
        view.bottomColor = UIColor.groupTableViewBackground
        view.cornerRadius = 30
        return view
    }()
    
    private lazy var handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.groupTableViewBackground
        view.backgroundColor?.withAlphaComponent(0.5)
        view.layer.cornerRadius = 3
        view.layer.zPosition = 1
        return view
    }()
    
    private lazy var handleOverlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 30)
        let view = UICollectionView(frame: (CGRect(x: 0, y: 0, width: self.momentumView.frame.size.width - 10, height: self.momentumView.frame.height)), collectionViewLayout:layout)
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        return view
    }()
    
    let progressCircle = ProgressCircle(frame: .zero)
       
    
    private let panRecognier = InstantPanGestureRecognizer()
    
    private var animator = UIViewPropertyAnimator()
    private var percentageTextLabel: UILabel!
    
    private var isOpen = false
    private var animationProgress: CGFloat = 0
    
    private var closedTransform = CGAffineTransform.identity
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sevenDaysFromNow = Date().addingTimeInterval(7*24*60*60)
        #warning("THIS IS HARD CODED TO RUSSELLS ID.")
        DataService.instance.getEmployeeById(forUID: "5A9F29D7-ECDF-4B67-AF28-FD72A7EEA6B7") { (employee) in
            guard let employee = employee else { return }
            self.user = employee
            
            self.updateAmountOwedLabel(employee: employee, duration: 1.0)
            DataService.instance.getShiftsByEmployeeId(EmployeeId: employee.id, handler: { (shifts) in
                guard let shifts = shifts else { return }
                self.user.shifts = shifts
                self.updateScoreLabel(shifts: shifts, duration: 1.0)
                self.progressCircle.animate(to: calculateScoreFrom(shifts: shifts))
                self.items = self.shiftManager.selectShiftsBy(Employee: self.user, fromDate: Date(), toDate: sevenDaysFromNow)
                self.items = self.items.sorted(by: { (shiftA, shiftB) -> Bool in
                    return Double(shiftA.startTime) ?? 0.0 < Double(shiftB.startTime) ?? 1.0
                })
                self.collectionView.reloadData()
            })
            DataService.instance.getCompany(forUID: self.user.companyId, handler: { (company) in
                self.company = company
                LocationManager.shared.requestUserLocation()
                LocationManager.shared.startMonitoringGeofenceRegion(companyCoordinate: CLLocationCoordinate2D(latitude: self.company.latitude, longitude: self.company.longitude))
                print("Company is SET✅")
            })

        }
        collectionView.delegate = self
        collectionView.dataSource = self
        calendarView.delegate = self
        calendarView.dataSource = self
        self.view.backgroundColor = UIColor.white
        layout()
        panRecognier.addTarget(self, action: #selector(panned))
        handleOverlayView.addGestureRecognizer(panRecognier)
        
    }
    
    func updateAmountOwedLabel(employee: Employee1, duration: Double) {
        let numberOfUpdatesPerSecond = 30.0
        let numberOfUpdates = Int(duration * numberOfUpdatesPerSecond)
        for i in 1...numberOfUpdates {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration/numberOfUpdatesPerSecond/2.0) * Double(i)) {
                let formatter = NumberFormatter()
                formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
                formatter.numberStyle = .currency
                let amountOwed = employee.amountOwed / Double(numberOfUpdates) * Double(i)
                if let formattedAmountOwed = formatter.string(from: amountOwed as NSNumber) {
                    self.textLabel.text = "\(formattedAmountOwed)"
                }
            }
        }
    }
    
    func updateScoreLabel(shifts: [Shift1], duration: Double) {
        let numberOfUpdatesPerSecond = 30.0
        let numberOfUpdates = Int(duration * numberOfUpdatesPerSecond)
        for i in 1...numberOfUpdates {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration/numberOfUpdatesPerSecond/2.0) * Double(i)) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .percent
                let score = calculateScoreFrom(shifts: shifts) / Double(numberOfUpdates) * Double(i)
                guard let formattedScore = formatter.string(from: score as NSNumber) else { return }
                    self.scoreAmountLabel.text = "\(formattedScore)"
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
    }
    
    // MARK: - Layout
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        
        view.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 10).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: calendarBottomConstraintView.topAnchor).isActive = true
        //        calendarView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(momentumView)
        momentumView.layer.zPosition = 1
        momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        momentumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        momentumView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 40).isActive = true
        
        momentumView.addSubview(handleView)
        handleView.topAnchor.constraint(equalTo: momentumView.topAnchor, constant: 10).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        handleView.centerXAnchor.constraint(equalTo: momentumView.centerXAnchor).isActive = true
        
        
        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.6)
        momentumView.transform = closedTransform
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        momentumView.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: momentumView.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 15).isActive = true
        
        momentumView.addSubview(handleOverlayView)
        handleOverlayView.topAnchor.constraint(equalTo: momentumView.topAnchor).isActive = true
        handleOverlayView.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor).isActive = true
        handleOverlayView.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor).isActive = true
        handleOverlayView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 10).isActive = true
        
        calendarBottomConstraintView.addSubview(progressCircle)
        
        scoreAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: scoreAmountLabel, attribute: .centerX, relatedBy: .equal, toItem: progressCircle, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: scoreAmountLabel, attribute: .centerY, relatedBy: .equal, toItem: progressCircle, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: scoreAmountLabel, attribute: .width, relatedBy: .equal, toItem: progressCircle, attribute: .width, multiplier: 0.8, constant: 0.0),
            NSLayoutConstraint(item: scoreAmountLabel, attribute: .height, relatedBy: .equal, toItem: progressCircle, attribute: .height, multiplier: 0.7, constant: 0.0)
            ])
        
        titleContainer.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        
    }
    
    // MARK: - Animation
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded()
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        case .changed:
            var fraction = -recognizer.translation(in: momentumView).y / closedTransform.ty
            if isOpen { fraction *= -1 }
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        // todo: rubberbanding
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: momentumView).y
            let shouldClose = yVelocity > 0 // todo: should use projection instead
            if yVelocity == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            if isOpen {
                if !shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if shouldClose && animator.isReversed { animator.isReversed.toggle() }
            } else {
                if shouldClose && !animator.isReversed { animator.isReversed.toggle() }
                if !shouldClose && animator.isReversed { animator.isReversed.toggle() }
            }
            let fractionRemaining = 1 - animator.fractionComplete
            let distanceRemaining = fractionRemaining * closedTransform.ty
            if distanceRemaining == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 30)
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
            let preferredDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
            let durationFactor = CGFloat(preferredDuration / animator.duration)
            animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
        default: break
        }
    }
    
    private func startAnimationIfNeeded() {
        if animator.isRunning { return }
        let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4)
        animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
        animator.addAnimations {
            self.momentumView.transform = self.isOpen ? self.closedTransform : .identity
        }
        animator.addCompletion { position in
            if position == .end { self.isOpen.toggle() }
        }
        animator.startAnimation()
    }
    
}

//MARK: - Collection View Delegate Flow Layout
extension EmployeeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.8, height: view.frame.width * 0.2)
    }
    
}

//MARK: - UICollection View Data Source

extension EmployeeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell else { return UICollectionViewCell() }
        
        // The Upcoming shifts for this employee.
        let item = items[indexPath.row]
        cell.configure(with: item)
        cell.setCornerRadius()
        cell.layer.backgroundColor = UIColor.white.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shiftID = self.items[indexPath.row].id
        DataService.instance.getShiftById(ShiftId: shiftID) { (shift) in
            guard let shift = shift else { return }
            guard let punchInTime = shift.punchInTime else { return }
            guard let punchOutTime = shift.punchOutTime else { return }
            
            let companyCoordinate = CLLocationCoordinate2D(latitude: self.company.latitude, longitude: self.company.longitude)
            let employeeCoordinate = LocationManager.shared.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            
            let distance = LocationManager.shared.getDistanceImKMBetweenCoordinates(coordinate1: companyCoordinate, coordinate2: employeeCoordinate)
            
            if distance < 1 {
                
                let loadingView = LoadingView(frame: .zero)
                
                if punchInTime == "" {
                    DataService.instance.setPunchInTimeWith(ShiftId: shiftID, WithValue: "\(Date().timeIntervalSince1970)")
                    self.view.addSubview(loadingView)
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                        loadingView.complete()
                    }
                } else if punchOutTime == "" {
                    
                    let actualPunchOutTime = Date().timeIntervalSince1970
                    
                    DataService.instance.setPunchOutTimeWith(ShiftId: shiftID, WithValue: "\(actualPunchOutTime)")
                    self.view.addSubview(loadingView)
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                        loadingView.complete()
                    }
                    
                    
                    let punchInTimeAsDouble = Double(punchInTime)
                    let punchOutTimeAsDouble = Double(actualPunchOutTime)
                    let hoursWorked = (punchOutTimeAsDouble - punchInTimeAsDouble!) / 60.0 / 60.0
                    let earnedThisShift = self.user.hourlyRate * hoursWorked
                    
                    DataService.instance.changeValueOfAmountOwedWith(EmployeeId: self.user.id, value: self.user.amountOwed + earnedThisShift)
                    
                    
                    print("HOURS WORKED IS \(hoursWorked)")
                } else {
                    // SHOW ALERT SAYING YOU'VE ALREADY PUNCHED IN / OUT.
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "You've already punched!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "You are too far away!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
  
}

//MARK: Calendar Delegate + Data Source

extension EmployeeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let shiftManager = ShiftManager()
        if date.timeIntervalSince1970 != calendarView.today?.timeIntervalSince1970 {
            self.items = shiftManager.selectShiftsBy(Employee: user, withAGivenDate: date)
            self.items = self.items.sorted(by: { (shiftA, shiftB) -> Bool in
                return Double(shiftA.startTime) ?? 0.0 < Double(shiftB.startTime) ?? 1.0
            })
            self.collectionView.reloadData()
        } else {
            guard let today = calendarView.today else { return }
            let sevenDaysFromNow = today.addingTimeInterval(7*24*60*60)
            self.items = shiftManager.selectShiftsBy(Employee: user, fromDate: today, toDate: sevenDaysFromNow)
            self.items = self.items.sorted(by: { (shiftA, shiftB) -> Bool in
                return Double(shiftA.startTime) ?? 0.0 < Double(shiftB.startTime) ?? 1.0
            })
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - InstantPanGestureRecognizer
/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
    
}

