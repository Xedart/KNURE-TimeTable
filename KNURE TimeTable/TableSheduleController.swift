//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleController: UITableViewController {
    
    var shedule: Shedule!
    let shedulesListController = ShedulesListTableViewController()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("EXAMPLE", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)
        
        navigationItem.titleView = button
    }
    
    func showMenu(sender: UIButton) {
        navigationController?.pushViewController(shedulesListController, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = shedule.eventsInTime((NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section)))).count
        if numberOfRows > 0 {
            return numberOfRows
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let events = shedule.eventsInTime((NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * indexPath.section))))
        if events.isEmpty {
            let cell = tableView.dequeueReusableCellWithIdentifier("EmptyTableSheduleCell", forIndexPath: indexPath)
            return cell
        } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableSheduleCell", forIndexPath: indexPath) as! TableSheduleCell
        cell.configure(shedule, event: events[indexPath.row])
        return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSheduleHeader(section: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
