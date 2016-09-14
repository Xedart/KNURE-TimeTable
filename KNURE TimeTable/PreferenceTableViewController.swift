//
//  PreferenceTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel
//import SVProgressHUD

class PreferenceTableViewController: UITableViewController {
    
    //MARK: - Properties:
    
    var apnToken: String?
    var dataSource = [String]()
    var apnEnabledSchedules = [String: String]()
    let defaults = UserDefaults.standard
    
    //MARK: - ViewController life cycle:

    override func viewDidLoad() {
        super.viewDidLoad()

        //NavigationItem setup:
        let doneButton = UIBarButtonItem(title: AppStrings.Done, style: .done, target: self, action: #selector(PreferenceTableViewController.close))
        let title = TitleViewLabel(title: AppStrings.preferences)
        
        tableView.allowsSelection = false
        
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.titleView = title
        
        //Get apn token from appDelegate:
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        apnToken = appDelegate.deviceAPNToken
        
        parseAPNEnabledSchedules()
    }
    
    func parseAPNEnabledSchedules() {
        
        //clear dataSource:
        dataSource = [String]()
        
        if let apnEnabled = defaults.object(forKey: AppData.apnEnabledSchedulesKey) as? [String: String] {
            
            apnEnabledSchedules = apnEnabled
            
            for(title, _) in apnEnabled {
                dataSource.append(title)
            }
        }
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 1:
        if section == 0 {
            return 2
        }
        
        // Section 2:
        if apnToken != nil {
            if dataSource.isEmpty {
                return 1
            } else {
                return dataSource.count
            }
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesSwitcherCell", for: indexPath) as! PreferencesSwitcherCell
        
        cell.configure(row: indexPath.row)
        return cell
            
        case 1:
            if apnToken == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesPushEmptyCell", for: indexPath) as! PreferencesPushEmptyCell
                cell.setAPNDisabledTip()
                return cell
            } else {
                
                if dataSource.isEmpty {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesPushEmptyCell", for: indexPath) as! PreferencesPushEmptyCell
                    cell.setNoSchedulesTip()
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesPushCell", for: indexPath) as! PreferencesPushCell
                    cell.titleLabel.text = dataSource[indexPath.row]
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
    }
    
    // MARKL: - TableView delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func shouldAddScheduleToAPNDisabled(title: String) -> Bool {
        
        // load the saved shedules identifiers from defaults
        if let groups = defaults.object(forKey: AppData.savedGroupsShedulesKey) as? [String] {
            
            for groupTitle in groups {
                if groupTitle == title {
                    return true
                }
            }
        }
        
        if let teachers = defaults.object(forKey: AppData.savedTeachersShedulesKey) as? [String] {
            
            for teachcerTitle in teachers {
                if teachcerTitle == title {
                    return true
                }
            }
        }
        
        if let auditoryies = defaults.object(forKey: AppData.savedAuditoriesShedulesKey) as? [String] {
            
            for auditoryTitle in auditoryies {
                if auditoryTitle == title {
                    return true
                }
            }
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: AppStrings.unsubscribe, handler: { (action , indexPath) -> Void in
            
            let removedScheduleTitle = self.dataSource[indexPath.row]
            Server.removeAPNScheduleWith(title: removedScheduleTitle) { removedScheduleID in
                
                //Save unsubscribed schedule to APNDisabled schedules if needed:
                DispatchQueue.main.async {
                    if self.shouldAddScheduleToAPNDisabled(title: removedScheduleTitle) {
                        var apnDisabledSchedules = [String: String]()
                        if let apnDisabled = self.defaults.object(forKey: AppData.apnDisabledSchedulesKey) as? [String: String] {
                            apnDisabledSchedules = apnDisabled
                        }
                        apnDisabledSchedules[removedScheduleTitle] = removedScheduleID
                        self.defaults.set(apnDisabledSchedules, forKey: AppData.apnDisabledSchedulesKey)
                    }
                }
                
                self.parseAPNEnabledSchedules()
                
                if self.dataSource.isEmpty {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    return
                }
                // closing animation:
                DispatchQueue.main.async(execute: { () -> Void in
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    tableView.endUpdates()
                })
            }
        })
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UILabel(frame: tableView.rectForHeader(inSection: section))
        headerView.font = UIFont.systemFont(ofSize: 18)
        headerView.textColor = FlatGrayDark()
        headerView.textAlignment = .center
        headerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        if section == 0 {
            headerView.text = AppStrings.syncWithCalendar
        } else if section == 1 {
            headerView.text = AppStrings.pushNotifications
        }
        return headerView
    }
    
    
    
}
