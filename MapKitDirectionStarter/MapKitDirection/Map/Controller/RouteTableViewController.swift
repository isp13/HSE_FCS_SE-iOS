//
//  RouteTableViewController.swift
//  MapKitDirection
//
//  Created by Никита Казанцев on 08.02.2021.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class RouteTableViewController: UITableViewController {
    
    // This variable is used for storing an array of MKRouteStep object of a selected route
    var routeSteps = [MKRoute.Step]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return routeSteps.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = routeSteps[indexPath.row].instructions
        return cell
    }
    
}
