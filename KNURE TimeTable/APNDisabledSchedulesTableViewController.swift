//
//  APNDisabledSchedulesTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/14/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel
import SVProgressHUD

private let preferencesCellID = "PreferencesDPNDisabledCell"

class APNDisabledSchedulesTableViewController: UITableViewController {
    
    var dataSource = [String]()
    var apnDisabledSchedules = [String: String]()
    var apnEnabledSchedules = [String: String]()
    let defaults = UserDefaults.standard
    
    init() {
        super.init(style: .plain)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PreferenceDisabledScheduleCell.self, forCellReuseIdentifier: preferencesCellID)
        
        title = AppStrings.Back// back button title
        navigationItem.titleView = TitleViewLabel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parseAPNEnabledSchedules()
        parseAPNDisabledSchedules()
    }
    
    func parseAPNDisabledSchedules() {
        
        if let apnDisabled = defaults.object(forKey: AppData.apnDisabledSchedulesKey) as? [String: String] {
            
            apnDisabledSchedules = apnDisabled
            
            for(title, _) in apnDisabled {
                dataSource.append(title)
            }
        }
    }
    
    func parseAPNEnabledSchedules() {
        
        if let apnEnabled = defaults.object(forKey: AppData.apnEnabledSchedulesKey) as? [String: String] {
            apnEnabledSchedules = apnEnabled
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: preferencesCellID, for: indexPath) as! PreferenceDisabledScheduleCell
        
        cell.titleLabel.text = dataSource[indexPath.row]

        return cell
    }
 
    // MARK: UITableView Delegate:
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        let scheduleTitle = dataSource[indexPath.row]
        let scheduleID = apnDisabledSchedules[scheduleTitle]!
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let deviceToken = delegate.deviceAPNToken {
            
            Server.makeRequest(.addRecepient, parameters: nil, postBody: "scheduleTitle=\(scheduleTitle)&scheduleID=\(scheduleID)&deviceToken=\(deviceToken)", callback: { (data, responce, error) in
                
                if error != nil {
                    SVProgressHUD.showError(withStatus: AppStrings.Error)
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }
                
                let serverResponce = JSON(data: data!)
                let result = serverResponce["result"].stringValue
                
                if result == "success" {
                    
                    self.apnDisabledSchedules[scheduleTitle] = nil
                    self.apnEnabledSchedules[scheduleTitle] = scheduleID
                    self.defaults.set(self.apnEnabledSchedules, forKey: AppData.apnEnabledSchedulesKey)
                    self.defaults.set(self.apnDisabledSchedules, forKey: AppData.apnDisabledSchedulesKey)
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    SVProgressHUD.showError(withStatus: AppStrings.Error)
                    tableView.deselectRow(at: indexPath, animated: true)
                    return
                }
            })
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
    }
}











