//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

protocol TableSheduleControllerDelegate {
    func performScrollToToday()
}

class TableSheduleController: UITableViewController, CollectionScheduleViewControllerDelegate {
    
    //MARK: - DataSource:
    
    var shedule: Shedule! {
        didSet {
            if !shedule.shedule_id.isEmpty {
                DispatchQueue.main.async(execute: {
                    self.refresher.attributedTitle = NSAttributedString(string: "\(AppStrings.lastRefresh)\(self.shedule.lastRefreshDate)")
                    self.button.setTitle(self.shedule.shedule_id, for: UIControlState())
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.button.setTitle(AppStrings.ChooseSchedule, for: UIControlState())
                })
            }
        }
    }
    
    // MARK: - Properties:
    
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    var preferencesBarButton: UIBarButtonItem!
    var refresher: UIRefreshControl!
    var openSideMenuGesture: UISwipeGestureRecognizer!

    //MARK: - LifeCycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //navigationController will be nil on iPad and won't be nil on iPhone:
        if navigationController != nil {
            
            button.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
            button.addTarget(self, action: #selector(TableSheduleController.showMenu(_:)), for: .touchUpInside)
            
            navigationItem.titleView = button
            navigationController?.navigationBar.barTintColor = FlatWhite()
            
            // setnavigation items:
            sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainTabBarController.presentLeftMenuViewController(_:)))
            preferencesBarButton = UIBarButtonItem(image: UIImage(named: "PreferencesButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(TableSheduleController.showPreferencesMenu))
            
            navigationItem.leftBarButtonItem = sideInfoButton
            navigationItem.rightBarButtonItem = preferencesBarButton
        }
        
        tableView.emptyDataSetSource = self
        
        // gesture:
        openSideMenuGesture = UISwipeGestureRecognizer(target: self, action: #selector(MainTabBarController.presentLeftMenuViewController(_:)))
        tableView.addGestureRecognizer(openSideMenuGesture)
        
        //Refrecher:
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(TableSheduleController.refreshContent), for: UIControlEvents.valueChanged)
        tableView.backgroundView = refresher
        
        // Reload notification:
        NotificationCenter.default.addObserver(self, selector: #selector(TableSheduleController.reloadSelf), name: NSNotification.Name(rawValue: AppData.reloadTableView), object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func showMenu(_ sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        let menuNavigationController = UINavigationController(rootViewController: shedulesListController)
        menuNavigationController.navigationBar.barTintColor = FlatWhite()
        self.present(menuNavigationController, animated: true, completion: nil)
    }
    
    func showPreferencesMenu() {
        let preferencesController = storyboard?.instantiateViewController(withIdentifier: "PreferenceTableViewController") as! PreferenceTableViewController
        let preferenceNavigationController = UINavigationController(rootViewController: preferencesController)
        self.present(preferenceNavigationController, animated: true, completion: nil)
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if shedule.shedule_id.isEmpty {
            return 0
        }
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shedule.shedule_id.isEmpty {
            return 0
        }
        let numberOfRows = shedule.eventsInDay((Date(timeIntervalSinceNow: TimeInterval(AppData.unixDay * section)))).count
        return numberOfRows > 0 ? numberOfRows : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let events = shedule.eventsInDay((Date(timeIntervalSinceNow: TimeInterval(AppData.unixDay * (indexPath as NSIndexPath).section))))
        
        if events.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableSheduleCell", for: indexPath) as! LabelCell
            cell.EmptyLabel.text = AppStrings.NoEvents
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableSheduleCell", for: indexPath) as! TableSheduleCell
            cell.delegate = self
        cell.configure(shedule, event: events[indexPath.row])
        return cell
        }
    }
    
    // MARK: - TableView delegate:
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSheduleHeader(section: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func passScheduleToLeftController() {
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = shedule
    }
    
    func refreshContent() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpDateNotification"), object: nil)
    }
    
    func reloadSelf() {
        tableView.reloadData()
    }
}

    // MARK: - DZNEmptyDataSetSource

extension TableSheduleController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        tableView.tableFooterView = UIView()
        return NSAttributedString(string: AppStrings.NotChoosenSchedule, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: 1)])
    }
}

    // MARK: - TableSheduleControllerDelegate

extension TableSheduleController: TableSheduleControllerDelegate {
    func performScrollToToday() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}






