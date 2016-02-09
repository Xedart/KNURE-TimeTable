//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableSheduleCell", forIndexPath: indexPath)
        
        
        // Configure the cell...

        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSheduleHeader(section: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }


}
