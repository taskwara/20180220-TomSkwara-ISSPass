//
//  ServicesModule.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class ServicesModule: BaseModule {
    
    struct Pass {
        var riseTime: Date
        var setTime: Date
        var duration: Int
    }
    
    var passes = [Pass]()
    var isLoading = false
    
    private var mpBaseURL: String
    private var mpPassesPath: String
    private var mpPassCount: Int
    
    
    // MARK: - lifecycle section
    
    init(_ configuration: JSON) {
        mpBaseURL    = configuration["ServicesModule"]["BaseURL"].stringValue
        mpPassesPath = configuration["ServicesModule"]["PassesPath"].stringValue
        mpPassCount  = configuration["ServicesModule"]["PassCount"].intValue
    }
    
    
    // MARK: - API functions
    
    func getPasses(location: CLLocation, callback: APICallback?) {
        passes.removeAll()
        isLoading = true
        
        // configure request
        let requestURL = mpBaseURL + mpPassesPath
        let parameters = [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "alt": location.altitude == 0 ? 0.1 : location.altitude, // simulator alt = 0, api breaks for 0 alt
            "n":   mpPassCount] as [String : Any]
        
        // request passes
        Alamofire.request(requestURL, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseSwiftyJSON() { response in
                self.isLoading = false
                if let resultValue = response.value {
                    
                    // parse json data into API objects
                    self.parseData(resultValue)
                    
                } else {
                    print("nil value for passes data")
                }
                
                // handle callback if provided
                callback?(self.passes as AnyObject, response.error)
        }
    }
    
    
    // MARK: - parse response into model objects
    
    private func parseData(_ json: JSON) {
        
        print("pass data retrieved")
        
        for pass in json["response"].arrayValue {
            
            // parse pass
            let riseTime = Date(timeIntervalSince1970: TimeInterval(truncating: pass["risetime"].numberValue))
            let duration = pass["duration"].intValue
            let setTime  = riseTime.addingTimeInterval(Double(duration))
            let newPass  = Pass(riseTime: riseTime, setTime: setTime, duration: duration)
            passes.append(newPass)
        }
    }
    
}
