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
    var scheduleCollectionController: CollectionScheduleViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let firsNavigationController = viewControllers![0] as! UINavigationController
        let secondNavigationController = viewControllers![1] as! UINavigationController
        scheduleTableController = firsNavigationController.viewControllers[0] as! TableSheduleController
        scheduleCollectionController = secondNavigationController.viewControllers[0] as! CollectionScheduleViewController
        
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
            scheduleCollectionController.shedule = loadShedule(defaultKey)
            dispatch_async(dispatch_get_main_queue(), {
                self.scheduleTableController.tableView.reloadData()
                self.scheduleCollectionController.collectionView!.reloadData()
            })
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleTableController.tableView.reloadData()
            //
            scheduleCollectionController.shedule = Shedule()
            scheduleCollectionController.collectionView!.reloadData()
        }
    }
}

// MARK: - NSNotifications setting:

extension MainTabBarController {
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.getNewSchedule), name: AppData.initNotification, object: nil)
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
