//
//  SchedulesDownoalTableView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import DataModel

    // MARK: - Data Source structures

struct ListRow {
    var row_id: String
    var row_title: String
}

struct ListSection {
    var title: String
    var rows: [ListRow]
    
    // check for already added rows:
    func containsRow(_ rowId :String) -> Bool {
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

class SchedulesDownoalTableView: UITableViewController {
    
    // MARK: - Data Source:
    
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
        initializeData()
        
        //Search
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SchedulesDownoalTableView.searchButtonTapped(_:)))
        searchButton.tintColor = AppData.appleButtonDefault
        searchField.delegate = self
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        searchField.frame.size.width = self.view.frame.width - 120.0
    }
    
    // MARK: - Table view data source and Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewScheduleCellId") as! NewScheduleCell
        if isAlreadyAdded(dataSource[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].row_title) {
            cell.doneLabel.text = AppStrings.Added
        } else {
            cell.doneLabel.text = ""
        }
        cell.titleLbl.text = dataSource[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].row_title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleViewLabel(title: (" \(dataSource[section].title)"))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: - Methods:
    
    func isAlreadyAdded(_ row: String) -> Bool {
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
        DispatchQueue.main.async(execute: {
            indicator.center = self.view.center
            self.tableView.addSubview(indicator)
            indicator.activityIndicatorViewStyle = .gray
            indicator.startAnimating()
        })
        
        Server.makeRequest(initMetod, parameters: nil, callback: { ( data, responce, error) in
           
            // check for success connection:
            if error != nil {
                self.present(AlertView.getAlert(AppStrings.Error, message: AppStrings.CheckInternet, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }), animated: true, completion: nil)
                indicator.stopAnimating()
                return
            }
            let jsonStr = String(data: data!, encoding: String.Encoding.windowsCP1251)
            let dataFromString = jsonStr!.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            if self.initMetod == .getGroups {
                Parser.parseGroupsLst(json, callback: { data in
                    self.dataSource = data
                    DispatchQueue.main.async(execute: {
                        indicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem = self.searchButton
                        self.tableView.reloadData()
                    })
                })
            } else if self.initMetod == .getTeachers {
                Parser.parseTeachersList(json, callback: { data in
                    self.dataSource = data
                    DispatchQueue.main.async(execute: {
                        indicator.stopAnimating()
                        self.navigationItem.rightBarButtonItem = self.searchButton
                        self.tableView.reloadData()
                    })
                })
            } else if self.initMetod == .getAudytories {
                Parser.parseAuditoriesList(json, callback: { data in
                    self.dataSource = data
                    DispatchQueue.main.async(execute: {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check for already added schedule:
        let cell = tableView.cellForRow(at: indexPath) as! NewScheduleCell
        if !cell.doneLabel.text!.isEmpty {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        // first thread:
        DispatchQueue.main.async(execute: {
        
            var type_id = 0
            if self.initMetod == .getGroups {
                type_id = 1
            } else if self.initMetod == .getTeachers {
                type_id = 2
            } else {
                type_id = 3
            }
        Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(self.dataSource[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].row_id)&type_id=\(type_id)"], callback: { (data, responce, error) in
            // check for success connection:
            if error != nil {
                
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.showError(withStatus: AppStrings.ScheduleDidNonDownloaded)
                })
                return
            }
            
            let jsonStr = String(data: data!, encoding: String.Encoding.windowsCP1251)
            let dataFromString = jsonStr!.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            
            Parser.parseSchedule(json, callback: { data in
                data.shedule_id = self.dataSource[indexPath.section].rows[indexPath.row].row_title
                data.scheduleIdentifier = self.dataSource[indexPath.section].rows[indexPath.row].row_id
                // saving new schedule to the defaults:
                let defaults = UserDefaults.standard
                if self.initMetod == .getGroups {
                    self.groupsData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                defaults.set(self.groupsData, forKey: AppData.savedGroupsShedulesKey)
                } else if self.initMetod == .getTeachers {
                    self.teachersData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                    defaults.set(self.teachersData, forKey: AppData.savedTeachersShedulesKey)
                } else if self.initMetod == .getAudytories {
                    self.auditoryiesData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                    defaults.set(self.auditoryiesData, forKey: AppData.savedAuditoriesShedulesKey)
                }
                
                // set new default schedule:
                defaults.set(self.dataSource[indexPath.section].rows[indexPath.row].row_title, forKey: AppData.defaultScheduleKey)
                defaults.synchronize()
                // save just-dowloaded schedule object to the file appending by schedule's title:
                data.saveShedule()
                // reloading schedules view with new schedule object:
                NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.initNotification), object: nil)
             })
          })
       })
        // second thread:
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
        })
    }
}

    // MARK: - SearchBarDelegate:

extension SchedulesDownoalTableView: UISearchBarDelegate {
    func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        // search field:
        searchField.frame = CGRect(x: 10, y: 4, width: 1, height: 40)
        let wrapper = UIBarButtonItem(customView: searchField)
        navigationItem.leftBarButtonItem = wrapper
        UIView.animate(withDuration: 0.2, animations: {
            self.searchField.frame.size.width += self.view.frame.width - 100
        })
        
        // cancell button:
        let cancelButton = UIBarButtonItem(title: AppStrings.Close, style: UIBarButtonItemStyle.plain, target: self, action: #selector(SchedulesDownoalTableView.cancelSearch(_:)))
        navigationItem.rightBarButtonItem = cancelButton
        searchField.becomeFirstResponder()
    }
    
    func cancelSearch(_ sender: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = searchButton
        dataSource = dataSourceStorage
        dataSourceStorage = [ListSection]()
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dataSourceStorage = dataSource
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
                if row.row_title.localizedCaseInsensitiveContains(searchText) {
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










