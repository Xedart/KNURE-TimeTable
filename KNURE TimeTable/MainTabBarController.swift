//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Data-source
    
    var scheduleTableController: TableSheduleController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let firsNavigationController = viewControllers![0] as! UINavigationController
        scheduleTableController = firsNavigationController.viewControllers[0] as! TableSheduleController
        // loading and transfering shedule provided by default:
        setObservers()
        initializeWithNewShedule()
    }
    
    // MARK: - Methods:
    func loadShedule(sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObjectWithFile("\(Shedule().urlPath.path!)/\(sheduleId)") as! Shedule
    }
}

extension MainTabBarController: SheduleControllersInitializer {
    func initializeWithNewShedule() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            scheduleTableController.shedule = loadShedule(defaultKey)
            dispatch_async(dispatch_get_main_queue(), {
                self.scheduleTableController.tableView.reloadData()
            })
            // TODO: add collection controller init here
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleTableController.tableView.reloadData()
            // TODO: add collection controller init here
        }
    }
}

// MARK: - NSNotifications setting:

extension MainTabBarController {
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getNewSchedule", name: AppData.initNotification, object: nil)
    }
}

// MARK: - Notifications responders:

extension MainTabBarController {
    func getNewSchedule() {
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
        self.initializeWithNewShedule()
    }
}
