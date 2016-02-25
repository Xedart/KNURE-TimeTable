//
//  DirectiongTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class DirectingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "назад"
        let titleView = TitleViewLabel()
        navigationItem.titleView = titleView
        titleView.text = "Додати"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleTypesCell", forIndexPath: indexPath) as! SchedulesTypesCell
        cell.configure(indexPath)
        return cell
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! SchedulesDownoalTableView
        destinationController.initMetod = .getGroups
    }
}









