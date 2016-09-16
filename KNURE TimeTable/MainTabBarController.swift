//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import DataModel

class MainTabBarController: UITabBarController {
    
    // MARK: - Data-source
    
    var scheduleTableController: TableSheduleController!
    var scheduleCollectionController: CollectionScheduleViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = FlatWhite()
        
        
        let firsNavigationController = viewControllers![0] as! UINavigationController
        let secondNavigationController = viewControllers![1] as! UINavigationController
        scheduleTableController = firsNavigationController.viewControllers[0] as! TableSheduleController
        scheduleCollectionController = secondNavigationController.viewControllers[0] as! CollectionScheduleViewController
        
        viewControllers![0].tabBarItem = UITabBarItem(title: AppStrings.Week, image: UIImage(named: "Week"), selectedImage: nil)
        viewControllers![1].tabBarItem = UITabBarItem(title: AppStrings.Semester, image: UIImage(named: "Semester"), selectedImage: nil)
        
        // loading and transfering shedule provided by default:
        setObservers()
        initWithDefaultSchedule()
        
        // updating schedule after default schedule was showed:
        updateCurrentSchedule()
    }
    
    // MARK: - Methods:
    
    func loadShedule(_ sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObject(withFile: "\(Shedule.urlPath.path)/\(sheduleId)") as! Shedule
    }
}

    //MARK: - SheduleControllersInitializer:

extension MainTabBarController: SheduleControllersInitializer {
    
    func initWithDefaultSchedule() {
        let defaults = UserDefaults.standard
        if let defaultKey = defaults.object(forKey: AppData.defaultScheduleKey) as? String {
            let newSchedule = loadShedule(defaultKey)
            scheduleTableController.shedule = newSchedule
            self.scheduleCollectionController.initialScrollDone = false
            scheduleCollectionController.shedule = newSchedule
            
            //set schedule object to shared container:
            newSchedule.saveScheduleToSharedContainer()
        } else {
            scheduleTableController.shedule = Shedule()
            self.scheduleCollectionController.initialScrollDone = false
            scheduleCollectionController.shedule = Shedule()
        }
        // pass schedule to sideMenu:
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = scheduleTableController.shedule

    }
    
    func initializeWithNewShedule() {
        self.initWithDefaultSchedule()
        DispatchQueue.main.async(execute: {
            self.scheduleCollectionController.collectionView!.reloadData()
            self.scheduleCollectionController.initialScrollDone = false
            self.scheduleCollectionController.shedule.performCache()
        })
        DispatchQueue.main.async(execute: {
            self.scheduleTableController.tableView.reloadData()
        })
    }
    
    func updateCurrentSchedule() {
        let defaults = UserDefaults.standard
        if let timeTableId = defaults.object(forKey: AppData.defaultScheduleKey) as? String {
            let scheduleIdentifier = scheduleTableController.shedule.scheduleIdentifier
            if scheduleIdentifier.isEmpty {
                self.scheduleTableController?.refreshControl?.endRefreshing()
                return
            }
            Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(scheduleIdentifier)"], postBody: nil, callback: { (data, responce, error) in
                // check for success connection:
                if error != nil {
                    print("responce")
                    print(error)
                    self.scheduleTableController?.refreshControl?.endRefreshing()
                    return
                }
                
                let jsonStr = String(data: data!, encoding: String.Encoding.windowsCP1251)
                let dataFromString = jsonStr!.data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = JSON(data: dataFromString!)
                
                
                
                // Parse result:
                Parser.parseSchedule(json, callback: { data in
                    data.shedule_id = timeTableId
                    data.scheduleIdentifier = self.scheduleTableController.shedule.scheduleIdentifier
                    data.notes = self.scheduleTableController.shedule.notes
                    // copy custom data from old schedule:
                    data.customData = self.scheduleCollectionController.shedule.customData
                    data.mergeData()
                    if data.days.isEmpty {
                        self.scheduleTableController?.refreshControl?.endRefreshing()
                        return
                    }
                    // Updating table schedule controller:
                    DispatchQueue.main.async(execute: {
                        self.scheduleTableController.shedule = data
                        self.scheduleTableController.tableView.reloadData()
                    })
                    
                    //Updating collection schedule controller:
                    DispatchQueue.main.async(execute: {

                        DispatchQueue.global(qos: .default).async(execute: {
                        
                            data.performCache()
                            
                            if self.scheduleCollectionController.shedule.numberOfDaysInSemester() == data.numberOfDaysInSemester() {
                                DispatchQueue.main.async(execute: {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.performBatchUpdates({self.scheduleCollectionController.collectionView?.reloadData()}, completion: nil)
                                
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.openNoteTextView), object: nil)
                                    }
                                    self.scheduleTableController?.refreshControl?.endRefreshing()
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.reloadData()
                                    self.scheduleCollectionController.configureDateScale()
                                    self.scheduleTableController?.refreshControl?.endRefreshing()
                                })
                            }
                        })
                    })
                    
                    //set updated schedule to the file:
                    if data.shedule_id.isEmpty {
                        return
                    }
                    data.saveShedule()
                    data.saveScheduleToSharedContainer()
                    
                    // pass schedule to sideMenu:
                    let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
                    leftSideMenu.schedule = self.scheduleTableController.shedule
                })
            })
        }
    }
}

    // MARK: - NSNotifications setting:

extension MainTabBarController {
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.getNewSchedule), name: NSNotification.Name(rawValue: AppData.initNotification), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.reloadViewController), name: NSNotification.Name(rawValue: AppData.reloadNotification), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.relodAfetrBecameActive), name: NSNotification.Name(rawValue: didEnterToActive), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.updateCurrentSchedule), name: NSNotification.Name(rawValue: "UpDateNotification"), object: nil)
    }
}

    // MARK: - Notifications responders:

extension MainTabBarController {
    func getNewSchedule() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
        self.initializeWithNewShedule()
    }
    
    func reloadViewController() {
        scheduleTableController.tableView.reloadData()
        scheduleCollectionController.collectionView?.reloadData()
    }
    
    func relodAfetrBecameActive() {
        scheduleTableController.tableView.reloadData()
    }
}
