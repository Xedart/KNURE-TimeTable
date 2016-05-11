//
//  TableSheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ChameleonFramework

class TableSheduleCell: UITableViewCell {
    
    //MARK: - IBOutlets:

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
    
// configuring:
    
    func configure(shedule: Shedule, event: Event) {
        displayedEvent = event
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.node.frame = self.bounds
            self.node.clipsToBounds = true
            self.node.cornerRadius = 15.0
            self.node.borderWidth = 0.5
            self.node.borderColor = AppData.colorsForPairOfType(Int(event.type)).colorWithAlphaComponent(0.8).CGColor
            self.node.backgroundColor =  AppData.colorsForPairOfType(Int(event.type)).colorWithAlphaComponent(0.1)
            
            // time widget:

            let now = Int(NSDate().timeIntervalSince1970)
            
            if now >= event.start_time && now <= event.end_time {
                let difference: CGFloat = (((CGFloat(event.end_time) - CGFloat(now)) / 5700) * 100)
                let yOffset = self.bounds.height - CGFloat(((difference * CGFloat(self.bounds.height)) / 100))
                print(yOffset)
                self.timeNode.frame = CGRect(x: 0, y: yOffset, width: self.bounds.width, height: 1.0)
                self.timeNode.backgroundColor = UIColor.redColor()
                dispatch_async(dispatch_get_main_queue()) {
                    self.node.view.addSubview(self.timeNode.view)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.timeNode.view.removeFromSuperview()
                }
            }
            })
        dispatch_async(dispatch_get_main_queue()) {
            // touch gesture recognizer:
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableSheduleCell.presentInfoMenu(_:)))
            self.addGestureRecognizer(tapGestureRecognizer)
            self.addSubview(self.node.view)
            self.sendSubviewToBack(self.node.view)
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

    }
    
    func presentInfoMenu(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewControllerWithIdentifier("EventDetailViewController") as! UINavigationController
        eventDetailViewController.modalPresentationStyle = .FormSheet
        eventDetailViewController.modalTransitionStyle = .CrossDissolve
        delegate.presentViewController(eventDetailViewController, animated: true, completion: nil)
        let destionationController = eventDetailViewController.viewControllers[0] as! EventDetailViewController
        destionationController.delegate = delegate
        destionationController.displayedEvent = displayedEvent
        destionationController.currentSchedule = delegate.shedule
    }
}
