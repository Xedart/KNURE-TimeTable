//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainTabBarController: UITabBarController {
    
    // MARK: - Data-source
    
    var scheduleTableController: TableSheduleController!
    var scheduleCollectionController: CollectionScheduleViewController!
    let defaults = NSUserDefaults.standardUserDefaults()

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
    
    func initWithDefaultSchedule() {
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            let newSchedule = loadShedule(defaultKey)
            scheduleTableController.shedule = newSchedule
            self.scheduleCollectionController.initialScrollDone = false
            scheduleCollectionController.shedule = newSchedule
        } else {
            scheduleTableController.shedule = Shedule()
            self.scheduleCollectionController.initialScrollDone = false
            scheduleCollectionController.shedule = Shedule()
        }
    }
    
    func initializeWithNewShedule() {
        self.initWithDefaultSchedule()
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleCollectionController.collectionView!.reloadData()
            self.scheduleCollectionController.initialScrollDone = false
            self.scheduleCollectionController.cacheData()
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleTableController.tableView.reloadData()
        })
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
