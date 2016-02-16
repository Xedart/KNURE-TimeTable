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
        defaults.setObject(nil, forKey: AppData.defaultScheduleKey)
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            scheduleTableController.shedule = loadShedule(defaultKey)
            // TODO: add collection controller init here
        } else {
            scheduleTableController.shedule = Shedule()
            // TODO: add collection controller init here
        }
    }
}
