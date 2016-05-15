//
//  CollectionScheduleMultiCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionScheduleMultiCell: UICollectionViewCell {
    
    var displayedNodes: [Event]!
    var displayedEvent: Event!
    var delegate: CollectionScheduleViewControllerDelegate!
    var extraTopSpace = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            extraTopSpace = 17.0
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            extraTopSpace = 10.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(events: [Event], shedule: Shedule) {
        
        displayedNodes = events
        
        let scrollNode = ASScrollNode()
        scrollNode.userInteractionEnabled = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        scrollNode.frame = self.bounds
            
        for i in 0..<events.count {
            // textNode:
            let textNode = ASTextNode()
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            
            textNode.attributedString = NSAttributedString(string: "\(shedule.subjects[events[i].subject_id]!.briefTitle)\n\(shedule.types[events[i].type]!.short_name) \(events[i].auditory)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17), NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSParagraphStyleAttributeName: titleParagraphStyle])
            textNode.backgroundColor = UIColor.clearColor()
            
            // backGroundNode:
            let backgroundNode = ASDisplayNode()
            backgroundNode.frame = CGRect(x: (self.bounds.width + 1) * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height)
            backgroundNode.backgroundColor = AppData.colorsForPairOfType(Int(events[i].type)).colorWithAlphaComponent(0.3)
            backgroundNode.borderColor = AppData.colorsForPairOfType(Int(events[i].type)).CGColor
            backgroundNode.clipsToBounds = true
            backgroundNode.cornerRadius = 5.0
            backgroundNode.borderWidth = 1.0
            textNode.frame = CGRect(x: self.bounds.origin.x, y: self.extraTopSpace, width: self.bounds.width, height: self.bounds.height - self.extraTopSpace - 10)
            backgroundNode.addSubnode(textNode)
            
            // bookmark: 
            if shedule.getNoteWithTokenId(events[i].getEventId) != nil {
                let bookmarkImage = ASImageNode()
                bookmarkImage.frame = CGRect(x: 100, y: 1, width: 10, height: 40)
                bookmarkImage.image = UIImage(named: "DoneImage")
                backgroundNode.addSubnode(bookmarkImage)
            }
            
            // scrolling image tip:
            let scrollingImage = ASImageNode()
            scrollingImage.frame = CGRect(x: textNode.frame.width - 25, y: textNode.frame.height - 10, width: 20, height: 20)
            scrollingImage.image = UIImage(named: "ScrollIndicator")
            textNode.addSubnode(scrollingImage)
            //
            scrollNode.addSubnode(backgroundNode)
        }
            //
            dispatch_async(dispatch_get_main_queue()) {
                scrollNode.view.contentSize.width = (self.bounds.width + 1) * CGFloat(events.count)
                for subView in self.subviews {
                    subView.removeFromSuperview()
                }
                // adding tap gestures to the nodes:
                var counter = 0
                for textNode in scrollNode.subnodes {
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionScheduleMultiCell.presentInfoMenu(_:)))
                    textNode.userInteractionEnabled = true
                    textNode.view.addGestureRecognizer(tapGestureRecognizer)
                    textNode.view.tag = counter
                    counter += 1
                }
                self.addSubview(scrollNode.view)
        }
    })
        
  }
    
    // MARK: - Info menu
    
    func presentInfoMenu(sender: UITapGestureRecognizer) {
        displayedEvent = displayedNodes[sender.view!.tag]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewControllerWithIdentifier("EventDetailViewController") as! UINavigationController
        eventDetailViewController.modalPresentationStyle = .FormSheet
        eventDetailViewController.modalTransitionStyle = .CrossDissolve
        delegate.presentViewController(eventDetailViewController, animated: true, completion: nil)
        let destionationController = eventDetailViewController.viewControllers[0] as! EventDetailViewController
        destionationController.delegate = delegate
        destionationController.currentSchedule = delegate.shedule
        destionationController.displayedEvent = displayedEvent
    }
}