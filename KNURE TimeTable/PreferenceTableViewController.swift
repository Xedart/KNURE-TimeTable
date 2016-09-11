//
//  PreferenceTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class PreferenceTableViewController: UITableViewController {
    
    var apnToken: String?
    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //NavigationItem setup:
        let doneButton = UIBarButtonItem(title: AppStrings.Done, style: .done, target: self, action: #selector(PreferenceTableViewController.close))
        let title = TitleViewLabel(title: AppStrings.preferences)
        
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
        
        let defaults = UserDefaults.standard
        if let apnEnabledSchedules = defaults.object(forKey: AppData.apnEnabledSchedulesKey) as? [String: String] {
            
            for(title, _) in apnEnabledSchedules {
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
                    return UITableViewCell()
                }
            }
        default:
            return UITableViewCell()
        }
    }
    
    // MARKL: - TableView delegate
    
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
