//
//  TodayViewController.swift
//  Tomorrow schedule
//
//  Created by Shkil Artur on 8/18/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import NotificationCenter
import DataModel

class TomorrowViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var tomorrowScheduleTableView: UITableView!
    
    var fontColor = UIColor.black
    var schedule: Shedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get shared shedule:
        schedule = loadSharedSchedule()
        
        tomorrowScheduleTableView.dataSource = self
        tomorrowScheduleTableView.delegate = self
        
        if #available(iOSApplicationExtension 10.0, *) {
            if contentHeight() > 110.0 {
                self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
            }
            
        } else {
            // set fontColor to the white on older version of iOS (9)
            fontColor = UIColor.white
            let height = contentHeight()
            preferredContentSize = CGSize(width: 0, height: height)
        }
    }
    
    func widgetPerformUpdate(_ completionHandler: ((NCUpdateResult) -> Void)) {
        
        let sharedDefaults = UserDefaults(suiteName: AppData.sharedContainerIdentifier)
        
        if let isScheduleUpdated = sharedDefaults?.bool(forKey: AppData.isScheduleUpdated) {
            if isScheduleUpdated {
                // load updated schedule, and redraw widget's content before iOS will take snapshot:
                schedule = loadSharedSchedule()
                // set proper largest content height:
                if contentHeight() > 110.0 {
                    if #available(iOSApplicationExtension 10.0, *) {
                        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    if #available(iOSApplicationExtension 10.0, *) {
                        extensionContext?.widgetLargestAvailableDisplayMode = .compact
                    } else {
                        // Fallback on earlier versions
                    }
                }
                let height = contentHeight()
                preferredContentSize = CGSize(width: 0, height: height)
                tomorrowScheduleTableView.reloadData()
                // set mark no notify that schedule is up to date:
                sharedDefaults?.set(false, forKey: AppData.isScheduleUpdated)
                sharedDefaults?.synchronize()
                completionHandler(NCUpdateResult.newData)
                return
            }
            completionHandler(NCUpdateResult.noData)
        }
        completionHandler(NCUpdateResult.noData)
    }
    
    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            let height = contentHeight()
            preferredContentSize = CGSize(width: 0, height: height)
        }
    }
    
    // Sub methods:
    
    func loadSharedSchedule() -> Shedule? {
        
        let path = Shedule.urlForSharedScheduleContainer()
        let shedule = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Shedule
        return shedule
    }
    
    func contentHeight() -> CGFloat {
        
        // 42.5  - tableview row height
        //25.0 - table view header height
        //110.0 - standart minimum size
        
        if schedule == nil {
            return 110.0
        }
        
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        return 42.5 * CGFloat(schedule!.eventsInDay(tomorrow).count) + 25.0
    }
}

// MARK: UITableViewDataSource delegate and dataSource:


extension TomorrowViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule == nil {
            return 0
        }
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        return schedule!.eventsInDay(tomorrow).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TomorrowTableViewCell", for: indexPath) as! TodayTbaleViewCell
        
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        let events = schedule!.eventsInDay(tomorrow)
        
        cell.configure(fontColor: fontColor, event: events[indexPath.row], schedule: schedule!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if schedule == nil {
            let label = UILabel()
            //label textstyle:
            if fontColor == UIColor.white {
                label.textColor = UIColor.lightGray
            } else {
                label.textColor = UIColor.darkGray
            }
            label.textAlignment = .center
            label.text = AppStrings.NotChoosenSchedule
            return label
        }

        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let label = UILabel()
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        label.text = "\(schedule!.shedule_id), \(AppStrings.Tomorrow), \(formatter.string(from: tomorrow))"
        if fontColor == UIColor.white {
            label.textColor = UIColor.lightGray
        } else {
            label.textColor = UIColor.darkGray
        }
        label.textAlignment = .center
        return label
    }
    
}


















