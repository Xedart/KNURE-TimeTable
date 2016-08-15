//
//  ShedulesListTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/13/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
//import ChameleonFramework

class ShedulesListTableViewController: UITableViewController {
    
    // MARK: - DataSource

    var groupsData = [String]()
    var teachersData = [String]()
    var auditoryiesData = [String]()
    var addButton: UIBarButtonItem!
    var closeButton: UIBarButtonItem!
    
    // delegate:
    var delegate: SheduleControllersInitializer!
    
    init() {
        super.init(style: UITableViewStyle.plain)
        tableView.register(SheduleLIstCell.self, forCellReuseIdentifier: "ShedulesListCell")
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ShedulesListTableViewController.addButtonPressed(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        // close button:
        closeButton = UIBarButtonItem(title: AppStrings.Done, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShedulesListTableViewController.dismissSelf))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func dismissSelf() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        title = AppStrings.Back// back button title
        navigationItem.titleView = TitleViewLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // load the saved shedules identifiers from defaults
        let defaults = UserDefaults.standard
        if let groups = defaults.object(forKey: AppData.savedGroupsShedulesKey) as? [String] {
            groupsData = groups
        }
        if let teachers = defaults.object(forKey: AppData.savedTeachersShedulesKey) as? [String] {
            teachersData = teachers
        }
        if let auditoryies = defaults.object(forKey: AppData.savedAuditoriesShedulesKey) as? [String] {
            auditoryiesData = auditoryies
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if groupsData.count == 0 && teachersData.count == 0 && auditoryiesData.count == 0 {
            return 0
        }
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupsData.count == 0 && teachersData.count == 0 && auditoryiesData.count == 0 {
            return 0
        }
        if section == 0 {
            return groupsData.count > 0 ? groupsData.count : 1
        }
        if section == 1 {
            return teachersData.count > 0 ? teachersData.count : 1
        } else {
            return auditoryiesData.count > 0 ? auditoryiesData.count : 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get the cell from queue:
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShedulesListCell", for: indexPath) as! SheduleLIstCell
        
        // configure the cell:
        if (indexPath as NSIndexPath).section == 0 {
            if groupsData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(groupsData[(indexPath as NSIndexPath).row], row: (indexPath as NSIndexPath).row)
            }
        }
        if (indexPath as NSIndexPath).section == 1 {
            if teachersData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(teachersData[(indexPath as NSIndexPath).row], row: (indexPath as NSIndexPath).row)
            }
        }
        if (indexPath as NSIndexPath).section == 2 {
            if auditoryiesData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(auditoryiesData[(indexPath as NSIndexPath).row], row: (indexPath as NSIndexPath).row)
            }
        }
        return cell
    }
    
    // MARK: - TableView Delegate:
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 {
            if groupsData.isEmpty {
                return false
            }
        } else if (indexPath as NSIndexPath).section == 1 {
            if teachersData.isEmpty {
                return false
            }
        } else if (indexPath as NSIndexPath).section == 2 {
            if auditoryiesData.isEmpty {
                return false
            }
        }
        return true
    }
    
    func chooseProperSchedule(_ scheduleToDelete: String) -> Bool {
        let defaults = UserDefaults.standard
        
        // choosing among groups:
        if groupsData.count > 0 {
            var counter = 0
            for group in groupsData {
                if scheduleToDelete != group {
                    defaults.set(group, forKey: AppData.defaultScheduleKey)
                    let cell = tableView.cellForRow(at: IndexPath(row: counter, section: 0)) as! SheduleLIstCell
                    cell.titleLbl.text?.append(" ✓")
                    return true
                }
                counter += 1
            }
        }
        
        // choosing among teachers:
        if teachersData.count > 0 {
            var counter = 0
            for group in teachersData {
                if scheduleToDelete != group {
                    defaults.set(group, forKey: AppData.defaultScheduleKey)
                    let cell = tableView.cellForRow(at: IndexPath(row: counter, section: 0)) as! SheduleLIstCell
                    cell.titleLbl.text?.append(" ✓")
                    return true
                }
                counter += 1
            }
        }
        
        // choosing among auditories:
        if auditoryiesData.count > 0 {
            var counter = 0
            for group in auditoryiesData {
                if scheduleToDelete != group {
                    defaults.set(group, forKey: AppData.defaultScheduleKey)
                    let cell = tableView.cellForRow(at: IndexPath(row: counter, section: 0)) as! SheduleLIstCell
                    cell.titleLbl.text?.append(" ✓")
                    return true
                }
                counter += 1
            }
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let defaults = UserDefaults.standard
        let deleteAction = UITableViewRowAction(style: .default, title: AppStrings.Delete, handler: { (action , indexPath) -> Void in
            
            var defaultSchedule = defaults.object(forKey: AppData.defaultScheduleKey) as? String
            if defaultSchedule == nil {
                defaultSchedule = ""
            }
            
            if (indexPath as NSIndexPath).section == 0 {
                _ = self.deleteFile("\(Shedule.urlPath.path)/\(self.groupsData[indexPath.row])")
                if self.groupsData[(indexPath as NSIndexPath).row] == defaultSchedule {
                    
                    if !self.chooseProperSchedule(self.groupsData[indexPath.row]) {
                        defaults.set(nil, forKey: AppData.defaultScheduleKey)
                    }
                    NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.initNotification), object: nil)
                }
                self.groupsData.remove(at: indexPath.row)
                defaults.set(self.groupsData, forKey: AppData.savedGroupsShedulesKey)
                if self.groupsData.isEmpty {
                    tableView.reloadData()
                    return
                }
            } else if (indexPath as NSIndexPath).section == 1 {
                _ = self.deleteFile("\(Shedule.urlPath.path)/\(self.teachersData[indexPath.row])")
                if self.teachersData[indexPath.row] == defaultSchedule {
                    
                    if !self.chooseProperSchedule(self.teachersData[(indexPath as NSIndexPath).row]) {
                        defaults.set(nil, forKey: AppData.defaultScheduleKey)
                    }
                    NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.initNotification), object: nil)
                }
                self.teachersData.remove(at: indexPath.row)
                defaults.set(self.teachersData, forKey: AppData.savedTeachersShedulesKey)
                if self.teachersData.isEmpty {
                    tableView.reloadData()
                    return
                }
            } else if (indexPath as NSIndexPath).section == 2 {
                _ = self.deleteFile("\(Shedule.urlPath.path)/\(self.auditoryiesData[indexPath.row])")
                if self.auditoryiesData[(indexPath as NSIndexPath).row] == defaultSchedule {
                    if !self.chooseProperSchedule(self.auditoryiesData[(indexPath as NSIndexPath).row]) {
                        defaults.set(nil, forKey: AppData.defaultScheduleKey)
                    }
                    NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.initNotification), object: nil)
                }
                self.auditoryiesData.remove(at: (indexPath as NSIndexPath).row)
                defaults.set(self.auditoryiesData, forKey: AppData.savedAuditoriesShedulesKey)
                if self.auditoryiesData.isEmpty {
                    tableView.reloadData()
                    return
                }
            }
            // closing animation:
            DispatchQueue.main.async(execute: { () -> Void in
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                tableView.endUpdates()
            })
            //tableView.reloadData()
        })
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: tableView.rectForHeader(inSection: section))
        headerView.font = UIFont.systemFont(ofSize: 18)
        headerView.textColor = FlatGrayDark()
        headerView.textAlignment = .center
        headerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        if section == 0 {
            headerView.text = AppStrings.Schedules
        }
        if section == 1 {
            headerView.text = AppStrings.Teachers
        }
        if section == 2 {
            headerView.text = AppStrings.Audytories
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get default schedule:
        var newScheduleId = ""
        if indexPath.section == 0 {
            guard !groupsData.isEmpty else {
                return
            }
           newScheduleId = groupsData[indexPath.row]
        }
        if indexPath.section == 1 {
            guard !teachersData.isEmpty else {
                return
            }
            newScheduleId = teachersData[indexPath.row]
        }
        if indexPath.section == 2 {
            guard !auditoryiesData.isEmpty else {
                return
            }
            newScheduleId = auditoryiesData[indexPath.row]
        }
        
        // set the new default schedule:
        let defaults = UserDefaults.standard
        defaults.set(newScheduleId, forKey: AppData.defaultScheduleKey)
        
        // cgange default schedule
        self.delegate.initializeWithNewShedule()
        self.dismiss(animated: true, completion: nil)
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    // MARK: - Methods:
    
    func addButtonPressed(_ sender: UIBarButtonItem?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduletypesTableViewControler") as! DirectingTableViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func deleteFile(_ path: String) -> Bool{
        let exists = FileManager.default.fileExists(atPath: path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: path)
            }catch let error as NSError {
                print("error: \(error.localizedDescription)")
                return false
            }
        }
        return exists
    }
}

    // MARK: - DZNEmptyDataSetSource and delegate

extension ShedulesListTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: AppStrings.NoSchedule, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: 1), NSForegroundColorAttributeName: UIColor.lightGray])
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        tableView.tableFooterView = UIView()
        return NSAttributedString(string: AppStrings.Add, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: 1), NSForegroundColorAttributeName: AppData.appleButtonDefault.withAlphaComponent(0.9)])
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        self.addButtonPressed(nil)
    }
}
















