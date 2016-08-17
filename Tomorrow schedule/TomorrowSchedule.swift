//
//  TomorrowSchedule.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/17/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import NotificationCenter
import DataModel

class TomorrowSchedule: WidgetScheduleView {
    
    @IBOutlet weak var tomorrowScheduleTableView: UITableView!
    
    override func viewDidLoad() {
        //get shared shedule:
        schedule = loadSharedSchedule()
        
        tomorrowScheduleTableView.dataSource = self
        tomorrowScheduleTableView.delegate = self
        
        if #available(iOSApplicationExtension 10.0, *) {
            if #available(iOS 10.0, *) {
                self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                // Fallback on earlier versions
            }
        } else {
            // set fontColor to the white on older version of iOS (9)
            fontColor = UIColor.white
            let height = contentHeight()
            preferredContentSize = CGSize(width: 0, height: height)
        }

    }
    
    override func contentHeight() -> CGFloat {
        
        // 42.5  - tableview row height
        //25.0 - table view header height
        //200.0 - standart minimum size
        
        if schedule == nil {
            return 200.0
        }
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        return 42.5 * CGFloat(schedule!.eventsInDay(tomorrow).count) + 25.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule == nil {
            return 0
        }
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        return schedule!.eventsInDay(tomorrow).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTbaleViewCell", for: indexPath) as! TodayTbaleViewCell
        
        let tomorrow = Date(timeInterval: TimeInterval(AppData.unixDay), since: Date())
        let events = schedule!.eventsInDay(tomorrow)
        
        cell.configure(fontColor: fontColor, event: events[indexPath.row], schedule: schedule!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if schedule == nil {
            return nil
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
