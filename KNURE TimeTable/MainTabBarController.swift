//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

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
        initWithDefaultSchedule()
        
        // updating schedule after default schedule was showed:
        updateCurrentSchedule()
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
        // pass schedule to sideMenu:
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = scheduleTableController.shedule

    }
    
    func initializeWithNewShedule() {
        self.initWithDefaultSchedule()
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleCollectionController.collectionView!.reloadData()
            self.scheduleCollectionController.initialScrollDone = false
            self.scheduleCollectionController.shedule.performCache()
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleTableController.tableView.reloadData()
        })
    }
    
    func updateCurrentSchedule() {
        if let timeTableId = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            let scheduleIdentifier = scheduleTableController.shedule.scheduleIdentifier
            if scheduleIdentifier.isEmpty {
                return
            }
            Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(scheduleIdentifier)"], callback: { (data, responce, error) in
                // check for success connection:
                if error != nil {
                    return
                }
                let jsonStr = String(data: data!, encoding: NSWindowsCP1251StringEncoding)
                let dataFromString = jsonStr!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let json = JSON(data: dataFromString!)
                // Parse result:
                Parser.parseSchedule(json, callback: { data in
                    data.shedule_id = timeTableId
                    data.scheduleIdentifier = self.scheduleTableController.shedule.scheduleIdentifier
                    data.notes = self.scheduleTableController.shedule.notes
                    
                    // Updating table schedule controller:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.scheduleTableController.shedule = data
                        self.scheduleTableController.tableView.reloadData()
                    })
                    
                    //Updating collection schedule controller:
                    dispatch_async(dispatch_get_main_queue(), {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            
                            data.performCache()
                            
                            if self.scheduleCollectionController.shedule.numberOfDaysInSemester() == data.numberOfDaysInSemester() {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.performBatchUpdates({self.scheduleCollectionController.collectionView?.reloadData()}, completion: nil)
                                    /*
                                     let indexPaths = self.scheduleCollectionController.collectionView!.indexPathsForVisibleItems()
                                     
                                     var sectionsToReload = [Int]()
                                     for indexPath in indexPaths {
                                     if sectionsToReload.contains(indexPath.section) {
                                     continue
                                     }
                                     sectionsToReload.append(indexPath.section)
                                     }self.scheduleCollectionController.collectionView?.reloadSections(NSIndexSet(indexesInRange: NSRange(sectionsToReload.minElement()!...sectionsToReload.maxElement()!)))
                                     
                                     */
                                    //-----------------------------------------------------------------
                                    // TODO: implement smooth update of currently visible cells.      //
                                    //-----------------------------------------------------------------
                                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
                                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                                        NSNotificationCenter.defaultCenter().postNotificationName(AppData.openNoteTextView, object: nil)
                                    }
                                    print("UPDATED")
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.reloadData()
                                })
                            }
                        })
                    })
                    
                    //set updated schedule to the file:
                    data.saveShedule()
                    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.getNewSchedule), name: AppData.initNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.reloadViewController), name: AppData.reloadNotification, object: nil)
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
    
    func reloadViewController() {
        scheduleTableController.tableView.reloadData()
        scheduleCollectionController.collectionView?.reloadData()
    }
}
