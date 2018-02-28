//
//  ISSUtilities.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias APICallback = ((AnyObject?, Error?) -> ())

class ISSUtilities {
    
    // load JSON from bundled file
    class func loadJSONFromBundle(_ name:String) -> JSON {
        let emptyJSON = JSON([])
        // return empty JSON if file not available or properly formed
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let contents = try NSString(contentsOfFile: filePath, usedEncoding: nil) as String
                return JSON(parseJSON: contents)
            } catch {
                return emptyJSON
            }
        }
        return emptyJSON
    }
    
    // present a simple alert view
    class func presentSimpleAlertView(_ title: String, message: String, presentingViewController: UIViewController?, callback:APICallback?) {
        var viewController: UIViewController
        // use visible view controller if needed
        if presentingViewController == nil {
            viewController = UIApplication.shared.delegate!.window!!.rootViewController!
        } else {
            viewController = presentingViewController!
        }
        // optional callback handler
        let handler = {(alert: UIAlertAction!) in if callback != nil { callback!(nil, nil) } }
        // display simple alert modal
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // execute closure after delay
    open class func executeAfterDelay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
}
