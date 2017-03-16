//
//  PreferenceTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel
import SVProgressHUD

class PreferenceTableViewController: UITableViewController {
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesSwitcherCell", for: indexPath) as! PreferencesSwitcherCell
        
        cell.configure(row: indexPath.row)
        return cell
    }
    
    // MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = PreferencesHeaderView(frame: tableView.rectForHeader(inSection: section))
        headerView.configure(section: section)
        return headerView
    }
}
