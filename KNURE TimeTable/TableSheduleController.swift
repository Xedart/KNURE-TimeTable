//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol TableSheduleControllerDelegate {
    func performScrollToToday()
}

class TableSheduleController: UITableViewController, CollectionScheduleViewControllerDelegate {
    
    //MARK: - DataSource:
    
    var shedule: Shedule! {
        didSet {
            if !shedule.shedule_id.isEmpty {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(self.shedule.shedule_id, forState: .Normal)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(AppStrings.ChooseSchedule, forState: UIControlState.Normal)
                })
            }
        }
    }
    
    // MARK: - Properties:
    
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!

    //MARK: - LifeCycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(TableSheduleController.showMenu(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        navigationController?.navigationBar.barTintColor = FlatWhite()
        
        // setnavigation items:
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainTabBarController.presentLeftMenuViewController(_:)))
        navigationItem.leftBarButtonItem = sideInfoButton
        tableView.emptyDataSetSource = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func showMenu(sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        let menuNavigationController = SchedulesMenuNavigationViewController(rootViewController: shedulesListController)
        menuNavigationController.navigationBar.barTintColor = FlatWhite()
        self.presentViewController(menuNavigationController, animated: true, completion: nil)

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
            cell.delegate = self
        cell.configure(shedule, event: events[indexPath.row])
        return cell
        }
    }
    
    // MARK: - TableView delegate:
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSheduleHeader(section: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func passScheduleToLeftController() {
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = shedule
    }
}

    // MARK: - DZNEmptyDataSetSource

extension TableSheduleController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        tableView.tableFooterView = UIView()
        return NSAttributedString(string: AppStrings.NotChoosenSchedule, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: 1)])
    }
}

    // MARK: - TableSheduleControllerDelegate

extension TableSheduleController: TableSheduleControllerDelegate {
    func performScrollToToday() {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
}






