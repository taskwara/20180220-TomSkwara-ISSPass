//
//  AppContext.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppContext {
    
    static let sharedInstance = AppContext()
    
    let targetName = "ISS Passes"
    var versionString: String
    var appName: String
    var debugMode = false
    var configuration: JSON
    
    var locationModule: LocationModule
    var servicesModule: ServicesModule

    
    // MARK: - lifecycle section
    
    init() {
        // identify app name and version
        let shortVersionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        versionString = shortVersionString
        appName = "\(self.targetName) v\(shortVersionString)"
        print(appName)
        
        // make app aware of build configuration
        #if DEBUG
            self.debugMode = true
        #endif
        
        // load local configuration (supplement with remote configuration later)
        configuration = ISSUtilities.loadJSONFromBundle("Configuration")
        
        // initialize function modules
        locationModule = LocationModule(configuration)
        servicesModule = ServicesModule(configuration)
    }
    
    
    // MARK: - application delegates passed on to modules
    
    func applicationWillResignActive(_ application: UIApplication) {
        locationModule.applicationWillResignActive(application)
        servicesModule.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        locationModule.applicationDidEnterBackground(application)
        servicesModule.applicationDidBecomeActive(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        locationModule.applicationWillEnterForeground(application)
        servicesModule.applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        locationModule.applicationDidBecomeActive(application)
        servicesModule.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        locationModule.applicationWillTerminate(application)
        servicesModule.applicationWillTerminate(application)
    }
    
}
