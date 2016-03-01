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
        title = "назад"// title for back item
        button.addTarget(self, action: #selector(TableSheduleController.showMenu(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        tableView.emptyDataSetSource = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    func showMenu(sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        navigationController?.pushViewController(shedulesListController, animated: true)
    }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if shedule.shedule_id.isEmpty {
            return 0
        }
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shedule.shedule_id.isEmpty {
            return 0
        }
        let numberOfRows = shedule.eventsInDay((NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section)))).count
        return numberOfRows > 0 ? numberOfRows : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let events = shedule.eventsInDay((NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * indexPath.section))))
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

// MARK: - DZNEmptyDataSetSource

extension TableSheduleController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        tableView.tableFooterView = UIView()
        return NSAttributedString(string: "Розклад не обрано", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: 1)])
    }
}
