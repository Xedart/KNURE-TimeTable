//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleController: UITableViewController {
    
    //MARK: - DataSource:
    
    var shedule: Shedule! {
        didSet {
            if !shedule.shedule_id.isEmpty {
                button.setTitle(shedule.shedule_id, forState: .Normal)
            }
        }
    }
    
    // MARK: - Properties:
    
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()

    //MARK: - LifeCycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
    }
    
    func showMenu(sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(shedulesListController, animated: true)
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
