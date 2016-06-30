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
    let bookmarkImage = ASImageNode()
    var displayedEvent: Event!
    var extraTopSpace = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async(execute: {
            self.node.isUserInteractionEnabled = true
            self.addSubview(self.node.view)
            self.addSubview(self.backgroundNode.view)
            self.sendSubview(toBack: self.backgroundNode.view)

        })
        self.bookmarkImage.frame = CGRect(x: 105, y: 1, width: 10, height: 40)
        self.bookmarkImage.image = UIImage(named: "DoneImage")
        // touch gesture recognizer:
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectionScheduleCell.presentInfoMenu(_:)))
        self.node.view.addGestureRecognizer(self.tapGestureRecognizer)
        
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
            self.backgroundNode.backgroundColor = AppData.colorsForPairOfType(Int(events[0].type)).withAlphaComponent(0.3)
            self.backgroundNode.borderWidth = 1.0
            self.backgroundNode.borderColor =  AppData.colorsForPairOfType(Int(events[0].type)).cgColor
            self.backgroundNode.clipsToBounds = true
            self.backgroundNode.cornerRadius = 5.0
            
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .center
            self.node.attributedString = AttributedString(string: "\(shedule.subjects[events[0].subject_id]!.briefTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.darkGray(), NSParagraphStyleAttributeName: titleParagraphStyle])
            self.node.frame = CGRect(x: self.bounds.origin.x, y: self.extraTopSpace, width: self.bounds.width, height: self.bounds.height - self.extraTopSpace)
            self.node.backgroundColor = UIColor.clear()
            
            // bookmark:
            if shedule.getNoteWithTokenId(events[0].getEventId) != nil {
                DispatchQueue.main.async(execute: {
                    self.addSubview(self.bookmarkImage.view)
                })
            } else {
                DispatchQueue.main.async(execute: {
                   self.bookmarkImage.view.removeFromSuperview()
                })
            }
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
    }
}
