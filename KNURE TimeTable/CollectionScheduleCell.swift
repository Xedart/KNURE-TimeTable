//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol EventDetailInfoContainer {
    var currentSchedule: Shedule! { get set }
    var displayedEvent: Event! { get }
}

class CollectionScheduleCellParent: UICollectionViewCell  {
    func configure(events: [Event], shedule: Shedule) {
        print("sdkfksdfskdfhj")
    }
}

class CollectionScheduleCell: CollectionScheduleCellParent, EventDetailInfoContainer {
    
    let node = ASTextNode()
    let backgroundNode = ASDisplayNode()
    var tapGestureRecognizer: UITapGestureRecognizer!
    var displayedEvent: Event!
    var currentSchedule: Shedule!
    var delegate: CollectionScheduleViewControllerDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dispatch_async(dispatch_get_main_queue()) {
            self.node.userInteractionEnabled = true
            self.addSubview(self.node.view)
            self.addSubview(self.backgroundNode.view)
            self.sendSubviewToBack(self.backgroundNode.view)
        }
        
        // touch gesture recognizer:
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionScheduleCell.presentInfoMenu(_:)))
        self.node.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(events: [Event], shedule: Shedule) {
        
        displayedEvent = events[0]
        currentSchedule = shedule
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.backgroundNode.frame = self.bounds
            self.backgroundNode.backgroundColor = AppData.colorsForPairOfType(Int(events[0].type)).colorWithAlphaComponent(0.3)
            self.backgroundNode.borderWidth = 1.0
            self.backgroundNode.borderColor =  AppData.colorsForPairOfType(Int(events[0].type)).CGColor
            self.backgroundNode.clipsToBounds = true
            self.backgroundNode.cornerRadius = 5.0
            
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            self.node.attributedString = NSAttributedString(string: "\n\(shedule.subjects[events[0].subject_id]!.briefTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17), NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSParagraphStyleAttributeName: titleParagraphStyle])
            //self.node.measure(CGSize(width: self.bounds.width, height: self.bounds.height))
            self.node.frame = self.bounds
            self.node.backgroundColor = UIColor.clearColor()
        })
    }
    
    // MARK: - Info menu
    
    func presentInfoMenu(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewControllerWithIdentifier("EventDetailViewController") as! UINavigationController
        eventDetailViewController.modalPresentationStyle = .FormSheet
        delegate.presentViewController(eventDetailViewController, animated: true, completion: nil)
        let destionationController = eventDetailViewController.viewControllers[0] as! EventDetailViewController
        destionationController.delegate = self
    }
    
}









