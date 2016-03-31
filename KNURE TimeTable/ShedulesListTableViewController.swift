//
//  ShedulesListTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/13/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class ShedulesListTableViewController: UITableViewController {
    
    // MARK: - DataSource

    var groupsData = [String]()
    var teachersData = [String]()
    var auditoryiesData = [String]()
    var addButton: UIBarButtonItem!
    
    // delegate:
    var delegate: SheduleControllersInitializer!
    
    init() {
        super.init(style: UITableViewStyle.Plain)
        tableView.registerClass(SheduleLIstCell.self, forCellReuseIdentifier: "ShedulesListCell")
        addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ShedulesListTableViewController.addButtonPressed(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        title = "назад"// back button title
        navigationItem.titleView = TitleViewLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // load the saved shedules identifiers from defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if let groups = defaults.objectForKey(AppData.savedGroupsShedulesKey) as? [String] {
            groupsData = groups
        }
        if let teachers = defaults.objectForKey(AppData.savedTeachersShedulesKey) as? [String] {
            teachersData = teachers
        }
        if let auditoryies = defaults.objectForKey(AppData.savedAuditoriesShedulesKey) as? [String] {
            auditoryiesData = auditoryies
        }
        tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if groupsData.count == 0 && teachersData.count == 0 && auditoryiesData.count == 0 {
            return 0
        }
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get the cell from queue:
        let cell = tableView.dequeueReusableCellWithIdentifier("ShedulesListCell", forIndexPath: indexPath) as! SheduleLIstCell
        
        // configure the cell:
        if indexPath.section == 0 {
            if groupsData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(groupsData[indexPath.row], row: indexPath.row)
            }
        }
        if indexPath.section == 1 {
            if teachersData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(teachersData[indexPath.row], row: indexPath.row)
            }
        }
        if indexPath.section == 2 {
            if auditoryiesData.isEmpty {
                cell.configureAsEmpty()
            } else {
                cell.configure(auditoryiesData[indexPath.row], row: indexPath.row)
            }
        }
        return cell
    }
    
    // MARK: - TableView Delegate:
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: tableView.rectForHeaderInSection(section))
        headerView.font = UIFont.systemFontOfSize(18)
        headerView.textColor = FlatGrayDark()
        headerView.textAlignment = .Center
        headerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        if section == 0 {
            headerView.text = "Групи"
        }
        if section == 1 {
            headerView.text = "Викладачі"
        }
        if section == 2 {
            headerView.text = "Аудиторії"
        }
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(newScheduleId, forKey: AppData.defaultScheduleKey)
        
        // cgange default schedule
        self.delegate.initializeWithNewShedule()
        dismissViewControllerAnimated(true, completion: nil)
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - Methods:
    
    func addButtonPressed(sender: UIBarButtonItem?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("ScheduletypesTableViewControler") as! DirectingTableViewController
        navigationController?.pushViewController(controller, animated: true)
    }
}

    // MARK: - DZNEmptyDataSetSource and delegate

extension ShedulesListTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Додані розклади відсутні", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: 1), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        tableView.tableFooterView = UIView()
        return NSAttributedString(string: "Додати", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17, weight: 1), NSForegroundColorAttributeName: AppData.appleButtonDefault.colorWithAlphaComponent(0.9)])
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.addButtonPressed(nil)
    }
}
















