//
//  SchedulesDownoalTableView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

    // MARK: - dataSource structures

struct ListRow {
    var row_id: String
    var row_title: String
}

struct ListSection {
    var title: String
    var rows: [ListRow]
    
    // check for already added rows:
    func containsRow(rowId :String) -> Bool {
        for row in rows {
            if row.row_id == rowId {
                return true
            }
        }
        return false
    }
    //
    init() {
        self.title = String()
        self.rows = [ListRow]()
    }
}

//

//

class SchedulesDownoalTableView: UITableViewController {
    
    // MARK: - dataSource
    
    var dataSource = [ListSection]()
    var dataSourceStorage = [ListSection]()
    var initMetod: Server.Method!
    
    // MARK: - Properties:
    var groupsData = [String]()
    var teachersData = [String]()
    var auditoryiesData = [String]()
    var searchButton: UIBarButtonItem!
    var searchField = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        initializeData()
        
        //search
        searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(SchedulesDownoalTableView.searchButtonTapped(_:)))
        searchButton.tintColor = AppData.appleButtonDefault
        searchField.delegate = self
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        searchField.frame.size.width = self.view.frame.width - 120.0
    }
    
    // MARK: - Table view data source and Delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewScheduleCellId") as! NewScheduleCell
        if isAlreadyAdded(dataSource[indexPath.section].rows[indexPath.row].row_title) {
            cell.doneLabel.text = AppStrings.Added
        } else {
            cell.doneLabel.text = ""
        }
        cell.titleLbl.text = dataSource[indexPath.section].rows[indexPath.row].row_title
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleViewLabel(title: (" \(dataSource[section].title)"))
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // methods:
    
    func isAlreadyAdded(row: String) -> Bool {
        if initMetod == .getGroups {
            for group in groupsData {
                if group == row {
                    return true
                }
            }
        } else if initMetod == .getTeachers {
            for teacher in teachersData {
                if teacher == row {
                    return true
                }
            }
        } else if initMetod == .getAudytories {
            for auditory in auditoryiesData {
                if auditory == row {
                    return true
                }
            }
        }
        return false
    }
}

    // MARK: - Data-Initializer:

extension SchedulesDownoalTableView {
    
    func initializeData() {
        
        // setDownloading indicator:
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dispatch_async(dispatch_get_main_queue(), {
            indicator.center = self.view.center
            self.tableView.addSubview(indicator)
            indicator.activityIndicatorViewStyle = .Gray
            indicator.startAnimating()
        })
        
        Server.makeRequest(initMetod, parameters: nil, callback: { ( data, responce, error) in
           
            // check for success connection:
            if error != nil {
                self.presentViewController(AlertView.getAlert(AppStrings.Error, message: AppStrings.CheckInternet, handler: { action in
                    self.navigationController?.popViewControllerAnimated(true)
                }), animated: true, completion: nil)
                indicator.stopAnimating()
                return
            }
            let jsonStr = String(data: data!, encoding: NSWindowsCP1251StringEncoding)
            let dataFromString = jsonStr!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            if self.initMetod == .getGroups {
                Parser.parseGroupsLst(json, callback: { data in
                    self.dataSource = data
                    dispatch_async(dispatch_get_main_queue(), {
                        indicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem = self.searchButton
                        self.tableView.reloadData()
                    })
                })
            } else if self.initMetod == .getTeachers {
                Parser.parseTeachersList(json, callback: { data in
                    self.dataSource = data
                    dispatch_async(dispatch_get_main_queue(), {
                        indicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem = self.searchButton
                        self.tableView.reloadData()
                    })
                })
            } else if self.initMetod == .getAudytories {
                Parser.parseAuditoriesList(json, callback: { data in
                    self.dataSource = data
                    dispatch_async(dispatch_get_main_queue(), {
                        indicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem = self.searchButton
                        self.tableView.reloadData()
                    })

                })
            }
        })
    }
}

    // MARK: - dowload new Schedule

extension SchedulesDownoalTableView {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // check for already added schedule:
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewScheduleCell
        if !cell.doneLabel.text!.isEmpty {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        // first thread:
        dispatch_async(dispatch_get_main_queue(), {
        
            var type_id = 0
            if self.initMetod == .getGroups {
                type_id = 1
            } else if self.initMetod == .getTeachers {
                type_id = 2
            } else {
                type_id = 3
            }
        Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(self.dataSource[indexPath.section].rows[indexPath.row].row_id)&type_id=\(type_id)"], callback: { (data, responce, error) in
            // check for success connection:
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    SVProgressHUD.showErrorWithStatus(AppStrings.ScheduleDidNonDownloaded)
                })
                return
            }
            let jsonStr = String(data: data!, encoding: NSWindowsCP1251StringEncoding)
            let dataFromString = jsonStr!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            Parser.parseSchedule(json, callback: { data in
                data.shedule_id = self.dataSource[indexPath.section].rows[indexPath.row].row_title
                data.scheduleIdentifier = self.dataSource[indexPath.section].rows[indexPath.row].row_id
                // saving new schedule to the defaults:
                let defaults = NSUserDefaults.standardUserDefaults()
                if self.initMetod == .getGroups {
                    self.groupsData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                defaults.setObject(self.groupsData, forKey: AppData.savedGroupsShedulesKey)
                } else if self.initMetod == .getTeachers {
                    self.teachersData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                    defaults.setObject(self.teachersData, forKey: AppData.savedTeachersShedulesKey)
                } else if self.initMetod == .getAudytories {
                    self.auditoryiesData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                    defaults.setObject(self.auditoryiesData, forKey: AppData.savedAuditoriesShedulesKey)
                }
                
                // set new default schedule:
                defaults.setObject(self.dataSource[indexPath.section].rows[indexPath.row].row_title, forKey: AppData.defaultScheduleKey)
                defaults.synchronize()
                // save just-dowloaded schedule object to the file appending by schedule's title:
                data.saveShedule()
                // reloading schedules view with new schedule object:
                NSNotificationCenter.defaultCenter().postNotificationName(AppData.initNotification, object: nil)
             })
          })
       })
        // second thread:
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
            if let navigationController = self.navigationController {
                navigationController.popToRootViewControllerAnimated(true)
            }
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.show()
        })
    }
}

extension SchedulesDownoalTableView: UISearchBarDelegate {
    func searchButtonTapped(sender: UIBarButtonItem) {
        
        // search field:
        searchField.frame = CGRect(x: 10, y: 4, width: 1, height: 40)
        let wrapper = UIBarButtonItem(customView: searchField)
        navigationItem.leftBarButtonItem = wrapper
        UIView.animateWithDuration(0.2, animations: {
            self.searchField.frame.size.width += self.view.frame.width - 100
        })
        
        // cancell button:
        let cancelButton = UIBarButtonItem(title: AppStrings.Close, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SchedulesDownoalTableView.cancelSearch(_:)))
        navigationItem.rightBarButtonItem = cancelButton
        searchField.becomeFirstResponder()
    }
    
    func cancelSearch(sender: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = searchButton
        dataSource = dataSourceStorage
        dataSourceStorage = [ListSection]()
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        dataSourceStorage = dataSource
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataSource = dataSourceStorage
            tableView.reloadData()
            return
        }
        // performing search:
        var searchedData = [ListSection]()
        for rowlist in dataSourceStorage {
            var resultList = ListSection()
            resultList.title = rowlist.title
            for row in rowlist.rows {
                if row.row_title.localizedStandardContainsString(searchText) {
                    resultList.rows.append(row)
                }
            }
            if resultList.rows.isEmpty {
                continue
            }
            searchedData.append(resultList)
        }
        dataSource = searchedData
        tableView.reloadData()
    }
}










