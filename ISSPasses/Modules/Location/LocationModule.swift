//
//  LocationModule.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class LocationModule: BaseModule, CLLocationManagerDelegate {
    
    var location: CLLocation?
    
    private var mpAutoRefresh: Bool
    private var mpRefreshInterval: Int
    private var locationManager: CLLocationManager
    private var callback: APICallback?
    
    
    // MARK: - lifecycle section
    
    init(_ configuration: JSON) {
        mpAutoRefresh = configuration["LocationModule"]["AutoRefresh"].boolValue
        mpRefreshInterval = configuration["LocationModule"]["RefreshInterval"].intValue
        locationManager = CLLocationManager()

        super.init()

        // setup core location
        locationManager.delegate = self
    }
    
    
    // MARK: - API functions
    
    func getLocation(callback: APICallback?) {
        // get user authorization for location
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            self.promptForUserPermission()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // request location and respond asynchronously
        self.callback = callback
        locationManager.requestLocation()
    }
    
    func cancelPendingLocation() {
        // cancel location request
        locationManager.stopUpdatingLocation()
        self.callback = nil
    }
    
    private func promptForUserPermission() {
        // inform caller of permission error
        let error = NSError(domain: "LocationModule", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Location Not Authorized"])
        self.callback?(nil, error)
        
        // show permission requirement to user (after small delay for ui cleanup)
        let title = "Location Required"
        let message = "Your location is needed to determine next overhead passes of the ISS.\n\nPlease enable location services in the Settings app."
        ISSUtilities.executeAfterDelay(0.5) { ISSUtilities.presentSimpleAlertView(title, message: message, presentingViewController: nil, callback: nil) }
    }
    
    
    // MARK: core location delegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            self.promptForUserPermission()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // report error to caller
        callback?(nil, error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // report location to caller
        location = locations.first
        callback?(self.location, nil)
    }
    
}
