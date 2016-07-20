//
//  TableSheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit
//import ChameleonFramework

class TableSheduleCell: UITableViewCell {
    
    //MARK: - IBOutlets:

    @IBOutlet weak var customEventImage: UIImageView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var subjectType: UILabel!
    @IBOutlet weak var auditory: UILabel!
    @IBOutlet weak var statusImage: UIImageView!

    var tapGestureRecognizer: UITapGestureRecognizer!
    let node = ASDisplayNode()
    let timeNode = ASDisplayNode()
    var displayedEvent: Event!
    var delegate: CollectionScheduleViewControllerDelegate!
    var indexPath: IndexPath!
    
// configuring:
    
    func configure(_ shedule: Shedule, event: Event) {
        displayedEvent = event
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async(execute: {
            self.node.frame = self.bounds
            self.node.clipsToBounds = true
            self.node.cornerRadius = 15.0
            self.node.borderWidth = 0.3
            self.node.borderColor = AppData.colorsForPairOfType(Int(event.type)).withAlphaComponent(0.8).cgColor
            self.node.backgroundColor =  AppData.colorsForPairOfType(Int(event.type)).withAlphaComponent(0.13)
            
            // time widget:
            
            if !event.isCustom {
                let now = Int(Date().timeIntervalSince1970)
                
                if now >= event.start_time && now <= event.end_time {
                    let difference: CGFloat = (((CGFloat(event.end_time) - CGFloat(now)) / 5700) * 100)
                    let yOffset = self.bounds.height - CGFloat(((difference * CGFloat(self.bounds.height)) / 100))
                    self.timeNode.frame = CGRect(x: 0, y: yOffset, width: self.bounds.width, height: 1.0)
                    self.timeNode.backgroundColor = UIColor.red()
                    DispatchQueue.main.async {
                        self.node.view.addSubview(self.timeNode.view)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.timeNode.view.removeFromSuperview()
                    }
                }
            }
            })
        DispatchQueue.main.async {
            // touch gesture recognizer:
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableSheduleCell.presentInfoMenu(_:)))
            self.addGestureRecognizer(tapGestureRecognizer)
            self.addSubview(self.node.view)
            self.sendSubview(toBack: self.node.view)
        }
        subjectTitle.text = shedule.subjects[event.subject_id]!.fullTitle
        startTime.text = AppData.pairsStartTime[event.numberOf_pair]
        endTime.text = AppData.pairsEndTime[event.numberOf_pair]
        subjectType.text = shedule.types[event.type]!.full_name
        auditory.text = event.auditory
        
        // bookmark:
        if shedule.getNoteWithTokenId(event.getEventId) != nil {
            statusImage.image = UIImage(named: "tableBookmark")
        } else {
            statusImage.image = nil
        }
        
        // custom image:
        if event.isCustom {
            customEventImage.image = UIImage(named: "DoneImage")
        } else {
            customEventImage.image = nil
        }

    }
    
    func presentInfoMenu(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! UINavigationController
        eventDetailViewController.modalPresentationStyle = .formSheet
        eventDetailViewController.modalTransitionStyle = .crossDissolve
        delegate.presentViewController(eventDetailViewController, animated: true, completion: nil)
        let destionationController = eventDetailViewController.viewControllers[0] as! EventDetailViewController
        destionationController.delegate = delegate
        destionationController.displayedEvent = displayedEvent
        destionationController.currentSchedule = delegate.shedule
        
        // calculate indexPath:
        let startDate = Date(timeIntervalSince1970: TimeInterval(delegate.shedule.startDayTime))
        let section = startDate.differenceInDaysWithDate(Date(timeIntervalSince1970: TimeInterval(displayedEvent.start_time)))
        indexPath = IndexPath(row: displayedEvent.numberOf_pair - 1, section: section)
        
        destionationController.indexPath = self.indexPath
    }
}
