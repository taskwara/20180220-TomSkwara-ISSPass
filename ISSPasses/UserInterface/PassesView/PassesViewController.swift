//
//  PassesViewController.swift
//  ISSPasses
//
//  Created by Tom Skwara on 2/19/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit
import CoreLocation

class PassesViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var passes = [ServicesModule.Pass]()
    private let tableRefreshControl = UIRefreshControl()
    private let tableActivityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - lifecycle section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        tableView.refreshControl = tableRefreshControl
        tableRefreshControl.addTarget(self, action: #selector(refreshPasses(_:)), for: .valueChanged)
        tableActivityIndicator.activityIndicatorViewStyle = .gray
        tableView.backgroundView = tableActivityIndicator
        
        // load passes from data source
        reloadData()
        tableActivityIndicator.startAnimating()
    }
    
    
    // MARK: - data source
    
    func reloadData() {
        // get user location
        AppContext.sharedInstance.locationModule.getLocation() { location, error in
            if error == nil {
                if let currentLocation = location as? CLLocation {
                    // get passes for location
                    AppContext.sharedInstance.servicesModule.getPasses(location: currentLocation) { passes, error in
                        if error == nil {
                            // refresh table of passes
                            self.passes = passes as! [ServicesModule.Pass]
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            // update refresh-ui
            self.tableRefreshControl.endRefreshing()
            self.tableActivityIndicator.stopAnimating()
        }
    }
    
    @objc private func refreshPasses(_ sender: Any) {
        reloadData()
    }
    

    // MARK: table view delegates
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath) as! PassTableViewCell
        let pass = passes[indexPath.row]

        // build time span string
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "M/d/yyyy h:mm:ss a"
        cell.riseTimeLabel.text  = dateFormatter.string(from: pass.riseTime).uppercased()
        cell.durationLabel.text  = "\(pass.duration)"
        cell.setTimeLabel.text   = dateFormatter.string(from: pass.setTime).uppercased()
        
        // adjust font for smaller devices
        if view.frame.width < 375.0 {
            cell.riseTimeLabel.font = cell.riseTimeLabel.font.withSize(10.0)
            cell.durationLabel.font = cell.durationLabel.font.withSize(10.0)
            cell.setTimeLabel.font  = cell.setTimeLabel.font.withSize(10.0)
        }
        
        return cell
    }
    

}

