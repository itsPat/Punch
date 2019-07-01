//
//  LocationManager.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-29.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 150
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (accepted, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if accepted {
                print("User accepted Notifications.")
            }
        }
    }
    
    func requestUserLocation() {
        locationManager.requestLocation()
    }
    
    func startMonitoringGeofenceRegion(region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }
    
    func getDistanceImKMBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return (Double(location1.distance(from: location2)) / 1000.0)
        
    }
    
    func notifyUser(punchIn: Bool, region: CLRegion) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "You have \(punchIn ? "arrived" : "departed") would you like to punch \(punchIn ? "in" : "out")?"
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "location_change",
                                            content: notificationContent,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error Adding Notification: \(error)")
            }
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status change.
        requestUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Check that the distance between the user and the company is less than < 0.5KM.
        // If so approve the punch in. If not tell the user they are too far away.
        if let location = locations.first {
            currentLocation = location
//            getDistanceImKMBetweenCoordinates(coordinate1: currentLocation?.coordinate, coordinate2:)
            let region = CLCircularRegion(center: location.coordinate, radius: 500.0, identifier: "Work")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            if !locationManager.monitoredRegions.contains(region) {
                startMonitoringGeofenceRegion(region: region)
                print("Starting to monitor geofence region with center \(location.coordinate).✅")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Notify the user that they have arrived at work, if a shift object STARTDATE is found within 30 mins of current time, ask the user if they want to punch in.
        print("USER HAS ARRIVED AT WORK✅")
        notifyUser(punchIn: true, region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Notify the user that they have arrived at work, if a shift object ENDDATE is found within 30 mins of current time, ask the user if they want to punch out.
        print("USER HAS LEFT WORK✅")
        notifyUser(punchIn: false, region: region)
    }
}


