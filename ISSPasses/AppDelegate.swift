//
//  AppDelegate.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appContext: AppContext?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // initialize one and only application context
        appContext = AppContext.sharedInstance
        return true
    }

    
    // MARK: - application delegates passed on to application context

    func applicationWillResignActive(_ application: UIApplication) {
        appContext?.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        appContext?.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        appContext?.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appContext?.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        appContext?.applicationWillTerminate(application)
    }


}

