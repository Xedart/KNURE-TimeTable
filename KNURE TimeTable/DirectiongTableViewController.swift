//
//  DirectiongTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class DirectingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppStrings.Back
        let titleView = TitleViewLabel()
        navigationItem.titleView = titleView
        titleView.text = AppStrings.Add
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypesCell", for: indexPath) as! SchedulesTypesCell
        cell.tag = (indexPath as NSIndexPath).row
        cell.configure(indexPath)
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destination as! SchedulesDownoalTableView
        let cell = sender as! SchedulesTypesCell
        if cell.tag == 0 {
            destinationController.initMetod = .getGroups
        } else if cell.tag == 1 {
            destinationController.initMetod = .getTeachers
        } else {
            destinationController.initMetod = .getAudytories
        }
    }
}









