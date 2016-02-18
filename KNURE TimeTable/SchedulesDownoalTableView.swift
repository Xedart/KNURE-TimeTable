//
//  SchedulesDownoalTableView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/15/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

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
//

class SchedulesDownoalTableView: UITableViewController {
    
    // MARK: - dataSource
    
    var dataSource = [ListSection]()
    var initMetod: Server.Method!
    
    // MARK: - Properties:
    var groupsData = [String]()
    var teachersData = [String]()
    var auditoryiesData = [String]()
    
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        tableView.reloadData()
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
            cell.doneLabel.text = "добавлено"
        } else {
            cell.doneLabel.text = ""
        }
        cell.titleLbl.text = dataSource[indexPath.section].rows[indexPath.row].row_title
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleViewLabel(title: (dataSource[section].title))
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
    
    func saveShedule(schedule: Shedule, path: String) {
        let save = NSKeyedArchiver.archiveRootObject(schedule, toFile: "\(Shedule().urlPath.path!)/\(path)")
        if !save {
            print("Error when saving")
        }
    }
}

    // MARK: - Data-Initializer:

extension SchedulesDownoalTableView {
    
    func initializeData() {
        
        Server.makeRequest(initMetod, parameters: nil, callback: { ( data, responce, error) in
            // check for success connection:
            if error != nil {
                self.presentViewController(AlertView.getAlert("Сталася помилка", message: "Перевірте з'єднання з інтернетом", handler: { action in
                    self.navigationController?.popViewControllerAnimated(true)
                }), animated: true, completion: nil)
                return
            }
            let jsonStr = String(data: data!, encoding: NSWindowsCP1251StringEncoding)
            let dataFromString = jsonStr!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            Parser.parseGroupsLst(json, callback: { data in
                self.dataSource = data
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            })
        })
    }
}

    // MARK: - dowload new Schedule

extension SchedulesDownoalTableView {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dispatch_async(dispatch_get_main_queue(), {
        
        Server.makeRequest(.getSchedule, parameters: ["?timetable_id=\(self.dataSource[indexPath.section].rows[indexPath.row].row_id)"], callback: { (data, responce, error) in
            // check for success connection:
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                    SVProgressHUD.showErrorWithStatus("Не вдалося завантажити розклад")
                    //SVProgressHUD.dismiss()
                })
                return
            }
            let jsonStr = String(data: data!, encoding: NSWindowsCP1251StringEncoding)
            let dataFromString = jsonStr!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            Parser.parseSchedule(json, callback: { data in
                data.shedule_id = self.dataSource[indexPath.section].rows[indexPath.row].row_title
                // saving new schedule to the defaults:
                let defaults = NSUserDefaults.standardUserDefaults()
                if self.initMetod == .getGroups {
                    self.groupsData.append(self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                defaults.setObject(self.groupsData, forKey: AppData.savedGroupsShedulesKey)
                }
                
                // TODO: /// if if...
                
                // set new default schedule:
                defaults.setObject(self.dataSource[indexPath.section].rows[indexPath.row].row_title, forKey: AppData.defaultScheduleKey)
                defaults.synchronize()
                // save just-dowloaded schedule object to the file appending by schedule's title:
                self.saveShedule(data, path: self.dataSource[indexPath.section].rows[indexPath.row].row_title)
                // reloading schedules view with new schedule object:
                NSNotificationCenter.defaultCenter().postNotificationName(AppData.initNotification, object: nil)
             })
          })
       })
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










