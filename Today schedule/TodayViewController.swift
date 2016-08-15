//
//  TodayViewController.swift
//  Today schedule
//
//  Created by Shkil Artur on 7/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var todayEventsTableView: UITableView!
    
    var fontColor = UIColor.black
    var schedule: Shedule!
    var object = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        todayEventsTableView.dataSource = self
        todayEventsTableView.delegate = self
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // set fontColor to the white on older version of iOS (9)
            fontColor = UIColor.white
           preferredContentSize = CGSize(width: 0, height: 237.5)
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
            self.preferredContentSize = CGSize(width: 0, height: 237.5);
        }
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
    
    func configure(fontColor: UIColor) {
        
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
    }
}


    // MARK: UITableViewDataSource delegate and dataSource:


extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTbaleViewCell", for: indexPath) as! TodayTbaleViewCell
        cell.subjectTitleLabel.text = object
        cell.configure(fontColor: fontColor)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "КН-14-5, сегодня, 14.08"
        if fontColor == UIColor.white {
            label.textColor = UIColor.lightGray
        } else {
            label.textColor = UIColor.darkGray
        }
        label.textAlignment = .center
        return label
    }
    
}









