//
//  TodayViewController.swift
//  Today schedule
//
//  Created by Shkil Artur on 7/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import NotificationCenter
import DataModel

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var todayEventsTableView: UITableView!
    
    var fontColor = UIColor.black
    var schedule: Shedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get shared shedule:
        schedule = loadSharedSchedule()
        
        todayEventsTableView.dataSource = self
        todayEventsTableView.delegate = self
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // set fontColor to the white on older version of iOS (9)
            fontColor = UIColor.white
            let height = contentHeight()
           preferredContentSize = CGSize(width: 0, height: height)
        }
        
        
    }
    
    func widgetPerformUpdate(_ completionHandler: ((NCUpdateResult) -> Void)) {
        
        
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.noData)
    }
    
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
        //200.0 - standart minimum size
        
        if schedule == nil {
            return 200.0
        }
        
        let day = Date(timeIntervalSince1970: TimeInterval(1472728500))
        return 42.5 * CGFloat(schedule!.eventsInDay(day).count) + 25.0
    }
}


    //MARK: TodayViewControllerCell:


class TodayTbaleViewCell: UITableViewCell {
    
    //Interface outlets:
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var separatorLineView: UIView!
    
    @IBOutlet weak var subjectTitleLabel: UILabel!
    
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    func configure(fontColor: UIColor, event: Event, schedule: Shedule) {
        
        // set apropriate color to the label depends on version of notification center:
        
        startTimeLabel.textColor = fontColor
        endTimeLabel.textColor = fontColor
        subjectTitleLabel.textColor = fontColor
        
        additionalInfoLabel.clipsToBounds = true
        additionalInfoLabel.layer.cornerRadius = 5.0
        additionalInfoLabel.layer.borderWidth = 0.4
        if fontColor == UIColor.white {
            additionalInfoLabel.layer.borderColor = UIColor.lightGray.cgColor
            separatorLineView.backgroundColor = UIColor.lightGray
        } else {
            additionalInfoLabel.layer.borderColor = UIColor.darkGray.cgColor
            separatorLineView.backgroundColor = UIColor.darkGray
        }
        
        // Set content to labels:
        
        //start time/ end time:
        startTimeLabel.text = AppData.pairsStartTime[event.numberOf_pair]
        endTimeLabel.text = AppData.pairsEndTime[event.numberOf_pair]
        
        //subject label:
        subjectTitleLabel.text = schedule.subjects[event.subject_id]!.briefTitle
        
        //type and auditory label:
        additionalInfoLabel.backgroundColor = AppData.colorsForPairOfType(Int(event.type)).withAlphaComponent(0.3)
        additionalInfoLabel.text = " \(schedule.types[event.type]!.short_name), \(event.auditory)"
    }
}


    // MARK: UITableViewDataSource delegate and dataSource:


extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if schedule == nil {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule == nil {
            return 0
        }
        let day = Date(timeIntervalSince1970: TimeInterval(1472728500))
        return schedule!.eventsInDay(day).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTbaleViewCell", for: indexPath) as! TodayTbaleViewCell
        
        let day = Date(timeIntervalSince1970: TimeInterval(1472728500))
        let events = schedule!.eventsInDay(day)
        
        cell.configure(fontColor: fontColor, event: events[indexPath.row], schedule: schedule!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if schedule == nil {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let label = UILabel()
        label.text = "\(schedule!.shedule_id), сегодня, \(formatter.string(from: Date()))"
        if fontColor == UIColor.white {
            label.textColor = UIColor.lightGray
        } else {
            label.textColor = UIColor.darkGray
        }
        label.textAlignment = .center
        return label
    }
}









