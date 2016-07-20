//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionScheduleCell: UICollectionViewCell {
    
    // MARK: - Properties:
    
    let node = ASTextNode()
    let backgroundNode = ASDisplayNode()
    var tapGestureRecognizer: UITapGestureRecognizer!
    var delegate: CollectionScheduleViewControllerDelegate!
    let leftImageNode = ASImageNode()
    let rightImageNode = ASImageNode()
    var displayedEvent: Event!
    var extraTopSpace = CGFloat()
    var indexPath: IndexPath!
    var gestureRecognizer: UILongPressGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async(execute: {
            self.node.isUserInteractionEnabled = true
            self.addSubview(self.node.view)
            self.addSubview(self.backgroundNode.view)
            self.addSubview(self.leftImageNode.view)
            self.addSubview(self.rightImageNode.view)
            self.sendSubview(toBack: self.backgroundNode.view)

        })
        
        // configure the status images:
        self.leftImageNode.frame = CGRect(x: 4, y: self.frame.height - 18, width: 14, height: 14)
        self.rightImageNode.frame = CGRect(x: 20, y: self.frame.height - 18, width: 14, height: 14)
        
        // touch gesture recognizers:
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionScheduleCell.presentInfoMenu(_:)))
        self.node.view.addGestureRecognizer(self.tapGestureRecognizer)
        
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CollectionScheduleCell.presentCusomEventMenu(sender:)))
        self.node.view.addGestureRecognizer(gestureRecognizer)
        
        if UIDevice.current().userInterfaceIdiom == .pad {
            extraTopSpace = 17.0
        } else if UIDevice.current().userInterfaceIdiom == .phone {
            extraTopSpace = 10.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ events: [Event], shedule: Shedule) {
        displayedEvent = events[0]
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).async(execute: {
            self.backgroundNode.frame = self.bounds
            self.backgroundNode.backgroundColor = AppData.colorsForPairOfType(Int(events[0].type)).withAlphaComponent(0.25)
            self.backgroundNode.borderWidth = 1.0
            self.backgroundNode.borderColor =  AppData.colorsForPairOfType(Int(events[0].type)).withAlphaComponent(0.7).cgColor
            self.backgroundNode.clipsToBounds = true
            self.backgroundNode.cornerRadius = 5.0
            
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .center
            
            //truncate subject title if it's too long:
            let subjectTitle = shedule.subjects[events[0].subject_id]!.briefTitle.characters.count < 10 ? shedule.subjects[events[0].subject_id]!.briefTitle : shedule.subjects[events[0].subject_id]!.briefTitle.substring(to: shedule.subjects[events[0].subject_id]!.briefTitle.index(shedule.subjects[events[0].subject_id]!.briefTitle.startIndex, offsetBy: 10)).appending("...")
            
            //set text node content:
            self.node.attributedString = AttributedString(string: "\(subjectTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.darkGray(), NSParagraphStyleAttributeName: titleParagraphStyle])
            self.node.frame = CGRect(x: self.bounds.origin.x, y: self.extraTopSpace, width: self.bounds.width, height: self.bounds.height - self.extraTopSpace)
            self.node.backgroundColor = UIColor.clear()
            
            // Status images configuring:
            
            DispatchQueue.main.async(execute: {
                // event is custom and has a note:
                if events[0].isCustom && shedule.getNoteWithTokenId(events[0].getEventId) != nil {
                    self.leftImageNode.image = UIImage.init(named: "DoneImage")
                    self.rightImageNode.image = UIImage.init(named: "tableBookmark")
                }
                
                // event is custom and doesn't have note:
                else if events[0].isCustom && shedule.getNoteWithTokenId(events[0].getEventId) == nil {
                    self.leftImageNode.image = UIImage.init(named: "DoneImage")
                    self.rightImageNode.image = nil
                }
                
                // event isn't custom and has a note:
                else if !events[0].isCustom && shedule.getNoteWithTokenId(events[0].getEventId) != nil {
                    self.leftImageNode.image = UIImage.init(named: "tableBookmark")
                    self.rightImageNode.image = nil
                }
                
                // event hasn't note and isn't custom:
                else if !events[0].isCustom && shedule.getNoteWithTokenId(events[0].getEventId) == nil {
                    self.leftImageNode.image = nil
                    self.rightImageNode.image = nil
                }
            })
        })
    }
    
    // MARK: - Info menu
    
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
        destionationController.indexPath = indexPath
    }
    
    // MARK: - Custom event menu:
    
    func presentCusomEventMenu(sender: UILongPressGestureRecognizer) {
        
        guard !displayedEvent.isCustom else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customEventViewController = storyboard.instantiateViewController(withIdentifier: "CustomEventNavigationViewController") as! UINavigationController
        customEventViewController.modalPresentationStyle = .formSheet
        customEventViewController.modalTransitionStyle = .crossDissolve
        delegate.presentViewController(customEventViewController, animated: true, completion: nil)
        let destionationController = customEventViewController.viewControllers[0] as! CustomEventTableViewController
        destionationController.delegate = self.delegate
        destionationController.indexPath = self.indexPath
        
    }
}







