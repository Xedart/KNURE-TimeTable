//
//  MainSplitViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

protocol SheduleControllersInitializer {
    func initializeWithNewShedule()
}

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Properties:
    
    var sheduleNavigationController = UINavigationController()
    let button = TitleViewButton()
    var scheduleTableController: TableSheduleController!
    var scheduleCollectionController: CollectionScheduleViewController!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableController = viewControllers[0] as! TableSheduleController
        scheduleCollectionController = viewControllers[1] as! CollectionScheduleViewController
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationItem.titleView = self.button
            self.setObservers()
            self.button.addTarget(self, action: #selector(MainSplitViewController.showMenu(_:)), forControlEvents: .TouchUpInside)
            })
        initWithDefaultSchedule()
        
// displaying:
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
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
            self.scheduleCollectionController.cacheData()
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.scheduleTableController.tableView.reloadData()
        })
    }
    
    func initWithDefaultSchedule() {
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            let newSchedule = loadShedule(defaultKey)
            scheduleTableController.shedule = newSchedule
            scheduleCollectionController.shedule = newSchedule
            dispatch_async(dispatch_get_main_queue(), {
                self.button.setTitle(defaultKey, forState: UIControlState.Normal)
            })
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleCollectionController.shedule = Shedule()
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
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
        self.initializeWithNewShedule()
    }
}










