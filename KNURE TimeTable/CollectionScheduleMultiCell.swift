//
//  CollectionScheduleMultiCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionScheduleMultiCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(events: [Event], shedule: Shedule) {
        let scrollNode = ASScrollNode()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        scrollNode.frame = self.bounds
        for i in 0..<events.count {
            let textNode = ASTextNode()
            //textNode.measure(CGSize(width: self.bounds.width, height: self.bounds.height))
            textNode.frame = CGRect(x: (self.bounds.width + 1) * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height)
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            
            textNode.attributedString = NSAttributedString(string: "\n\(shedule.subjects[events[i].subject_id]!.briefTitle)\n\(shedule.types[events[i].type]!.short_name) \(events[i].auditory)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17), NSForegroundColorAttributeName: UIColor.darkGrayColor(), NSParagraphStyleAttributeName: titleParagraphStyle])
            textNode.backgroundColor = AppData.colorsForPairOfType(Int(events[i].type)).colorWithAlphaComponent(0.2)
            textNode.borderColor =  AppData.colorsForPairOfType(Int(events[0].type)).CGColor
            textNode.borderWidth = 1.0
            scrollNode.addSubnode(textNode)
        }
            dispatch_async(dispatch_get_main_queue()) {
                scrollNode.view.contentSize.width = (self.bounds.width + 1) * CGFloat(events.count)
                for subView in self.subviews {
                    subView.removeFromSuperview()
                }
                self.addSubview(scrollNode.view)
        }
    })
  }
}
