//
//  MainSplitViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import RESideMenu
import SwiftyJSON

protocol SheduleControllersInitializer {
    func initializeWithNewShedule()
}

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Properties:
    
    var sheduleNavigationController = UINavigationController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    var rightSideInfoButton: UIBarButtonItem!
    var scheduleTableController: TableSheduleController!
    var scheduleCollectionController: CollectionScheduleViewController!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup viewController:
        scheduleTableController = viewControllers[0] as! TableSheduleController
        scheduleCollectionController = viewControllers[1] as! CollectionScheduleViewController
        scheduleCollectionController.weekScheduleControllerDelegate = scheduleTableController
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationItem.titleView = self.button
            self.setObservers()
            self.button.addTarget(self, action: #selector(MainSplitViewController.showMenu(_:)), forControlEvents: .TouchUpInside)
            })
        
        // load saved schedule from the file:
        initWithDefaultSchedule()
        
        // updating schedule after default schedule was showed:
        updateCurrentSchedule()
        
        // setnavigation items:
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainSplitViewController.presentLeftMenuViewController(_:)))
        navigationItem.setLeftBarButtonItems([sideInfoButton, self.displayModeButtonItem()], animated: true)
        
        // displaying:
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
    }
    
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if self.displayMode == .AllVisible {
            return UISplitViewControllerDisplayMode.PrimaryHidden
        } else {
            return UISplitViewControllerDisplayMode.AllVisible
        }
    }
    
    override func displayModeButtonItem() -> UIBarButtonItem {
        let defaultButton = super.displayModeButtonItem()
        let button = UIBarButtonItem(image: UIImage(named: "displayModeButton"), style: UIBarButtonItemStyle.Plain, target: defaultButton.target, action: defaultButton.action)
        return button
    }
    
    // MARK: - Methods:
    
    func showMenu(sender: UIButton) {
        let sheduleListController = ShedulesListTableViewController()
        sheduleListController.delegate = self
        sheduleNavigationController = UINavigationController(rootViewController: sheduleListController)
        sheduleNavigationController.modalPresentationStyle = .Popover
        sheduleNavigationController.preferredContentSize = CGSize(width: 350, height: 500)
        let popoverMenuViewController = sheduleNavigationController.popoverPresentationController
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.permittedArrowDirections = .Up
        popoverMenuViewController?.sourceView = navigationItem.titleView
        popoverMenuViewController?.backgroundColor = UIColor.whiteColor()
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 10,
            width: button.bounds.width,
            height: button.bounds.height)
            presentViewController(sheduleNavigationController, animated: true, completion: nil)
    }
    
    // load schedule with specified id from the fiile:
    func loadShedule(sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObjectWithFile("\(Shedule().urlPath.path!)/\(sheduleId)") as! Shedule
    }
}

    // MARK: - SheduleControllersInitializer conformance:

extension MainSplitViewController: SheduleControllersInitializer {
    
    func initializeWithNewShedule() {
        self.initWithDefaultSchedule()
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleCollectionController.collectionView!.reloadData()
            self.scheduleCollectionController.initialScrollDone = false
            self.scheduleCollectionController.shedule.performCache()
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
            })
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleTableController.tableView!.reloadData()
        })
    }
    
    func initWithDefaultSchedule() {
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            let newSchedule = loadShedule(defaultKey)
            scheduleTableController.shedule = newSchedule
            scheduleCollectionController.shedule = newSchedule
            scheduleCollectionController.shedule.performCache()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.button.setTitle(defaultKey, forState: UIControlState.Normal)
            })
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleCollectionController.shedule = Shedule()
            scheduleCollectionController.shedule.performCache()
        }
        // pass schedule to sideMenu:
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = scheduleTableController.shedule

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
                    // TODO: data.notes = old.schedule.notes.

                    // Updating table schedule controller:
                    dispatch_async(dispatch_get_main_queue(), {
                        self.scheduleTableController.shedule = data
                        self.scheduleTableController.tableView.reloadData()
                    })
                    // 14-4
                    //Updating collection schedule controller:
                    dispatch_async(dispatch_get_main_queue(), {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            
                            data.performCache()
                            
                            if self.scheduleCollectionController.shedule.numberOfDaysInSemester() == data.numberOfDaysInSemester() {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.performBatchUpdates({self.scheduleCollectionController.collectionView?.reloadData()}, completion: nil)
                                    
                                    /*
                                    let vivsibleCells = self.scheduleCollectionController.collectionView?.visibleCells() as! [CollectionScheduleCellParent]
                                    let events = data.eventsCache["\(64)\(1)"]!.events
                                    dispatch_async(dispatch_get_main_queue(), {
                                    for cell in vivsibleCells {
                                        cell.configure(events, shedule: data)
                                    }
                                        })
                                    
                                    //-----------------------------------------------------------------
                                    // TODO: implement smooth update of currently visible cells.      //
                                    //-----------------------------------------------------------------
                                    */
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

    // MARK: - Pop all vieewController to root when dissmissing popover:

extension MainSplitViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        sheduleNavigationController.popToRootViewControllerAnimated(false)
    }
}

    // MARK: - NSNotifications setting:

extension MainSplitViewController {
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSplitViewController.getNewSchedule), name: AppData.initNotification, object: nil)
    }
}

    // MARK: - Notifications responders:

extension MainSplitViewController {
    func getNewSchedule() {
        
        self.initializeWithNewShedule()
    }
}










