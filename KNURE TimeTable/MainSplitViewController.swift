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
import DataModel

protocol SheduleControllersInitializer {
    func initializeWithNewShedule()
}

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Properties:
    
    var sheduleNavigationController: UINavigationController!
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    var preferencesBarButton: UIBarButtonItem!
    var scheduleTableController: TableSheduleController!
    var scheduleCollectionController: CollectionScheduleViewController!
    let defaults = UserDefaults.standard
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup viewController:
        scheduleTableController = viewControllers[0] as! TableSheduleController
        scheduleCollectionController = viewControllers[1] as! CollectionScheduleViewController
        scheduleCollectionController.weekScheduleControllerDelegate = scheduleTableController
        DispatchQueue.main.async(execute: {
            self.navigationItem.titleView = self.button
            self.setObservers()
            self.button.addTarget(self, action: #selector(MainSplitViewController.showMenu(_:)), for: .touchUpInside)
            })
        
        // load saved schedule from the file:
        initWithDefaultSchedule()
        
        // updating schedule after default schedule was showed:
        self.updateCurrentSchedule()
        
        // setnavigation items:
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainSplitViewController.presentLeftMenuViewController(_:)))
        let displayModeButton = UIBarButtonItem(image: UIImage(named: "displayModeButton"), style: UIBarButtonItemStyle.plain, target: super.displayModeButtonItem.target, action: super.displayModeButtonItem.action)
        
        preferencesBarButton = UIBarButtonItem(image: UIImage(named: "PreferencesButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainSplitViewController.showPreferencesMenu))
        
        // set buttons:
        navigationItem.setLeftBarButtonItems([sideInfoButton, displayModeButton], animated: true)
        navigationItem.setRightBarButton(preferencesBarButton, animated: true)
        
        
        // displaying:
        maximumPrimaryColumnWidth = CGFloat.greatestFiniteMagnitude
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .allVisible
    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if self.displayMode == .allVisible {
            return UISplitViewControllerDisplayMode.primaryHidden
        } else {
            return UISplitViewControllerDisplayMode.allVisible
        }
    }
    
    // MARK: - Methods:
    
    func showMenu(_ sender: UIButton) {
        let sheduleListController = ShedulesListTableViewController()
        sheduleListController.delegate = self
        sheduleNavigationController = UINavigationController(rootViewController: sheduleListController)
        sheduleNavigationController.modalPresentationStyle = .popover
        sheduleNavigationController.preferredContentSize = CGSize(width: 350, height: 500)
        let popoverMenuViewController = sheduleNavigationController.popoverPresentationController
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.sourceView = navigationItem.titleView
        popoverMenuViewController?.backgroundColor = UIColor.white
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 8,
            width: button.bounds.width,
            height: button.bounds.height)
            present(sheduleNavigationController, animated: true, completion: nil)
    }
    
    func showPreferencesMenu() {
        let preferencesController = storyboard?.instantiateViewController(withIdentifier: "PreferenceTableViewController") as! PreferenceTableViewController
        let preferenceNavigationController = UINavigationController(rootViewController: preferencesController)
        preferenceNavigationController.modalPresentationStyle = .formSheet
        preferenceNavigationController.modalTransitionStyle = .coverVertical
        self.present(preferenceNavigationController, animated: true, completion: nil)
    }
    
    // load schedule with specified id from the fiile:
    func loadShedule(_ sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObject(withFile: "\(Shedule.urlPath.path)/\(sheduleId)") as! Shedule
    }
}

    // MARK: - SheduleControllersInitializer:

extension MainSplitViewController: SheduleControllersInitializer {
    
    func initializeWithNewShedule() {
        self.initWithDefaultSchedule()
        DispatchQueue.main.async(execute: {
            self.scheduleCollectionController.collectionView!.reloadData()
            self.scheduleCollectionController.initialScrollDone = false
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
            })
        })
        DispatchQueue.main.async(execute: {
            self.scheduleTableController.tableView!.reloadData()
        })
    }
    
    func initWithDefaultSchedule() {
        
        if let defaultKey = defaults.object(forKey: AppData.defaultScheduleKey) as? String {
            let newSchedule = loadShedule(defaultKey)
            scheduleTableController.shedule = newSchedule
            scheduleCollectionController.shedule = newSchedule
            scheduleCollectionController.shedule.performCache()
            
            DispatchQueue.main.async(execute: {
                self.button.setTitle("\(defaultKey) ▼", for: UIControlState())
            })
            
            //set schedule object to shared container:
            newSchedule.saveScheduleToSharedContainer()
        } else {
            DispatchQueue.main.async(execute: {
                self.button.setTitle(AppStrings.ChooseSchedule, for: UIControlState())
            })
            scheduleTableController.shedule = Shedule()
            scheduleCollectionController.shedule = Shedule()
            scheduleCollectionController.shedule.performCache()
        }
        // pass schedule to sideMenu:
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = scheduleTableController.shedule
    }
    
    func updateCurrentSchedule() {
        if let timeTableId = defaults.object(forKey: AppData.defaultScheduleKey) as? String {
            let scheduleIdentifier = scheduleTableController.shedule.scheduleIdentifier
            if scheduleIdentifier.isEmpty {
                self.scheduleTableController?.refresher?.endRefreshing()
                return
            }
            Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(scheduleIdentifier)"], postBody: nil, callback: { (data, responce, error) in
                // check for success connection:
                if error != nil {
                    self.scheduleTableController?.refresher?.endRefreshing()
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
                        self.scheduleTableController?.refresher?.endRefreshing()
                        return
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppData.blockNoteTextView), object: nil)
                    // Updating table schedule controller:
                    DispatchQueue.main.async(execute: {
                        self.scheduleTableController.shedule = data
                        self.scheduleTableController.tableView.reloadData()
                    })
                    
                    //Update collection schedule controller:
                    DispatchQueue.main.async(execute: {
                        DispatchQueue.global(qos: .default).async(execute: {
                            
                            data.performCache()
                            
                            if self.scheduleCollectionController.shedule.numberOfDaysInSemester() == data.numberOfDaysInSemester() {
                                DispatchQueue.main.async(execute: {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.performBatchUpdates({self.scheduleCollectionController.collectionView?.reloadData()}, completion: nil)
                
                                    // unlock the keyBoard:
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppData.openNoteTextView), object: nil)
                                    }
                                    self.scheduleTableController?.refresher?.endRefreshing()
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    self.scheduleCollectionController.shedule = data
                                    self.scheduleCollectionController.collectionView?.reloadData()
                                    self.scheduleCollectionController.configureDateScale()
                                    self.scheduleTableController?.refresher?.endRefreshing()
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

    // MARK: - UIPopoverPresentationControllerDelegate

extension MainSplitViewController: UIPopoverPresentationControllerDelegate {
    
    //Pop all vieewController to root when dissmissing popover:
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        sheduleNavigationController?.popToRootViewController(animated: false)
    }
}

    // MARK: - NSNotifications setting:

extension MainSplitViewController {
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.getNewSchedule), name: NSNotification.Name(rawValue: AppData.initNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.reloadViewController), name: NSNotification.Name(rawValue: AppData.reloadNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.relodAfetrBecameActive), name: NSNotification.Name(rawValue: didEnterToActive), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainSplitViewController.updateCurrentSchedule), name: NSNotification.Name(rawValue: "UpDateNotification"), object: nil)
    }
}

    // MARK: - Notifications responders:

extension MainSplitViewController {
    func getNewSchedule() {
        
        self.initializeWithNewShedule()
    }
    
    func reloadViewController() {
        scheduleCollectionController.collectionView?.reloadData()
        scheduleTableController.tableView.reloadData()
    }
    
    func relodAfetrBecameActive() {
        scheduleTableController.tableView.reloadData()
        scheduleCollectionController.configureDateScale()
    }
}










