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

    override func viewDidLoad() {
        super.viewDidLoad()

        //NavigationItem setup:
        let doneButton = UIBarButtonItem(title: AppStrings.Done, style: .done, target: self, action: #selector(PreferenceTableViewController.close))
        let title = TitleViewLabel(title: AppStrings.preferences)
        
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.titleView = title
        
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesSwitcherCell", for: indexPath) as! PreferencesSwitcherCell
        
        cell.configure(row: indexPath.row)
        return cell
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
        }
        return headerView
    }
    
    
    
}
