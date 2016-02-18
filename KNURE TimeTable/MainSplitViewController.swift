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
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableController = viewControllers[0] as! TableSheduleController
        let sheduleListController = ShedulesListTableViewController()
        sheduleListController.delegate = self
        sheduleNavigationController = UINavigationController(rootViewController: sheduleListController)
        sheduleNavigationController.modalPresentationStyle = .Popover
        sheduleNavigationController.preferredContentSize = CGSize(width: 350, height: 500)
        
        navigationItem.titleView = button
        button.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)

// loading and transfering shedule provided by default:
        setObservers()
        initializeWithNewShedule()
        
// displaying:
        
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
    }
    
    // MARK: - Methods:
    
    func showMenu(sender: UIButton) {
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
    
    func loadShedule(sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObjectWithFile("\(Shedule().urlPath.path!)/\(sheduleId)") as! Shedule
    }
}

    // MARK: - SheduleControllersInitializer conformance:

extension MainSplitViewController: SheduleControllersInitializer {
    func initializeWithNewShedule() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            scheduleTableController.shedule = loadShedule(defaultKey)
            dispatch_async(dispatch_get_main_queue(), {
                self.scheduleTableController.tableView.reloadData()
                self.button.setTitle(defaultKey, forState: UIControlState.Normal)
            })
            // TODO: add collection controller init here
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleTableController.tableView.reloadData()
            // TODO: add collection controller init here
        }
    }
}

    // MARK: - pop all vieewController to root when dissmissing popOver:

extension MainSplitViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        sheduleNavigationController.popToRootViewControllerAnimated(false)
    }
}

    // MARK: - NSNotifications setting:

extension MainSplitViewController {
    func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getNewSchedule", name: AppData.initNotification, object: nil)
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










