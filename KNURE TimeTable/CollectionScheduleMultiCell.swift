//
//  CollectionScheduleMultiCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import DataModel

class CollectionScheduleMultiCell: UICollectionViewCell {
    
    var displayedNodes: [Event]!
    var displayedEvent: Event!
    var delegate: CollectionScheduleViewControllerDelegate!
    var extraTopSpace = CGFloat()
    var indexPath: IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            extraTopSpace = 17.0
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            extraTopSpace = 10.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ events: [Event], shedule: Shedule) {
        
        displayedNodes = events
        
        let scrollNode = ASScrollNode()
        scrollNode.isUserInteractionEnabled = true
        
        DispatchQueue.global(qos: .default).async(execute: {
            
            scrollNode.frame = self.bounds
            
            for i in 0..<events.count {
            
                // TextNode:
                let textNode = ASTextNode()
                let titleParagraphStyle = NSMutableParagraphStyle()
                titleParagraphStyle.alignment = .center
            
                //truncate subject title if it's too long:
                let subjectTitle = shedule.subjects[events[i].subject_id]!.briefTitle.characters.count < 10 ? shedule.subjects[events[i].subject_id]!.briefTitle : shedule.subjects[events[i].subject_id]!.briefTitle.substring(to: shedule.subjects[events[i].subject_id]!.briefTitle.index(shedule.subjects[events[i].subject_id]!.briefTitle.startIndex, offsetBy: 10)).appending("...")
            
                textNode.attributedString = NSAttributedString(string: "\(subjectTitle)\n\(shedule.types[events[i].type]!.short_name) \(events[i].auditory)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16), NSForegroundColorAttributeName: FlatWhite(), NSParagraphStyleAttributeName: titleParagraphStyle])
                textNode.frame = CGRect(x: self.bounds.origin.x, y: self.extraTopSpace, width: self.bounds.width, height: self.bounds.height - self.extraTopSpace - 10)
                textNode.backgroundColor = UIColor.clear
        
                // BackgroundNode:
                let backgroundNode = ASDisplayNode()
                backgroundNode.frame = CGRect(x: (self.bounds.width + 1) * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height)
                backgroundNode.backgroundColor = AppData.colorsForPairOfType(Int(events[i].type))
                backgroundNode.clipsToBounds = true
                backgroundNode.cornerRadius = 5.0
                backgroundNode.addSubnode(textNode)
            
            
                // Status images:
            
                // event is custom and has a note:
                if events[i].isCustom && shedule.getNoteWithTokenId(events[i].getEventId) != nil {
                    let leftStatusImage = ASImageNode()
                    let rightStatusImage = ASImageNode()
                    leftStatusImage.frame = CGRect(x: 4, y: self.frame.height - 18, width: 14, height: 14)
                    rightStatusImage.frame = CGRect(x: 20, y: self.frame.height - 18, width: 14, height: 14)
                    leftStatusImage.image = UIImage.init(named: "DoneImage")
                    rightStatusImage.image = UIImage.init(named: "tableBookmark")
                    backgroundNode.addSubnode(leftStatusImage)
                    backgroundNode.addSubnode(rightStatusImage)
                }
            
                    // event is custom and doesn't have note:
                else if events[i].isCustom && shedule.getNoteWithTokenId(events[i].getEventId) == nil {
                    let leftStatusImage = ASImageNode()
                    leftStatusImage.frame = CGRect(x: 4, y: self.frame.height - 18, width: 14, height: 14)
                    leftStatusImage.image = UIImage.init(named: "DoneImage")
                    backgroundNode.addSubnode(leftStatusImage)
                }
            
                    // event isn't custom and has a note:
                else if !events[i].isCustom && shedule.getNoteWithTokenId(events[i].getEventId) != nil {
                    let leftStatusImage = ASImageNode()
                    leftStatusImage.frame = CGRect(x: 4, y: self.frame.height - 18, width: 14, height: 14)
                    leftStatusImage.image = UIImage.init(named: "tableBookmark")
                    backgroundNode.addSubnode(leftStatusImage)
                }
           
            
                // Scrolling image:
                let scrollingImage = ASImageNode()
                scrollingImage.frame = CGRect(x: textNode.frame.width - 25, y: textNode.frame.height - 10, width: 20, height: 20)
                scrollingImage.image = UIImage(named: "ScrollIndicator")
                textNode.addSubnode(scrollingImage)
                
                // Gesture recognizers:
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionScheduleMultiCell.presentInfoMenu(_:)))
                let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CollectionScheduleMultiCell.presentCusomEventMenu(_:)))
                DispatchQueue.main.async {
                    textNode.isUserInteractionEnabled = true
                    textNode.view.tag = i
                    textNode.view.addGestureRecognizer(tapGestureRecognizer)
                    textNode.view.addGestureRecognizer(longGestureRecognizer)
                }
                scrollNode.addSubnode(backgroundNode)
            }
            
            //Configure Scroll view:
            let contentWidth = (self.bounds.width + 1) * CGFloat(events.count)
            DispatchQueue.main.async {
                scrollNode.view.contentSize.width = contentWidth
                for subView in self.subviews {
                    subView.removeFromSuperview()
                }
                self.addSubview(scrollNode.view)
            }
        })
  }
    
    // MARK: - Info menu
    
    func presentInfoMenu(_ sender: UITapGestureRecognizer) {
        displayedEvent = displayedNodes[sender.view!.tag]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! UINavigationController
        eventDetailViewController.modalPresentationStyle = .formSheet
        eventDetailViewController.modalTransitionStyle = .crossDissolve
        delegate.presentViewController(eventDetailViewController, animated: true, completion: nil)
        let destionationController = eventDetailViewController.viewControllers[0] as! EventDetailViewController
        destionationController.delegate = delegate
        destionationController.currentSchedule = delegate.shedule
        destionationController.displayedEvent = displayedEvent
        destionationController.indexPath = indexPath
    }
    
    func presentCusomEventMenu(_ sender: UILongPressGestureRecognizer) {
        
        if isThereCustomPair() {
            shakeAnimation()
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
    
    //Animation:
    
    func shakeAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.2, 0.5, 0.8, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        
        layer.add(animation, forKey: "shake")
    }
    
    //Sub-method:
    func isThereCustomPair() -> Bool {
        for event in self.displayedNodes {
            if event.isCustom {
                return true
            }
        }
        return false
    }
}




