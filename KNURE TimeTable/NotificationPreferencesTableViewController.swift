//
//  NotificationPreferencesTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/22/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

enum alarmTime: Int {
    case fifteenMinutes = 0
    case oneHour = 1
    case oneDay = 2
    case never = 3
}

class NotificationPreferencesTableViewController: UITableViewController {
    
    var delegate: EventDetailViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = AppStrings.recall
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationPreferencesCell", for: indexPath) as! NotificationPreferencesCell
        
        if indexPath.row == 0 {
            cell.alarmTimeLabel.text = "15 \(AppStrings.minutes)"
        } else if indexPath.row == 1 {
            cell.alarmTimeLabel.text = "1 \(AppStrings.hour)"
        } else if indexPath.row == 2 {
            cell.alarmTimeLabel.text = "1 \(AppStrings.day)"
        } else if indexPath.row == 3 {
            cell.alarmTimeLabel.text = AppStrings.dontRecall
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.alarmTimePreferences = alarmTime(rawValue: indexPath.row)!
        delegate.tableView.reloadData()
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
