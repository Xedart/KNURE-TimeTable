//
//  CollectionScheduleCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//.

import UIKit

class CollectionScheduleCell: UICollectionViewCell {
    
    let node = ASTextNode()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dispatch_async(dispatch_get_main_queue()) {
            self.addSubview(self.node.view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(events: [Event], shedule: Shedule) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            self.node.attributedString = NSAttributedString(string: "\n\(shedule.subjects[events[0].subject_id]!.briefTitle)\n\(shedule.types[events[0].type]!.short_name) \(events[0].auditory)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: titleParagraphStyle])
            //self.node.measure(CGSize(width: self.bounds.width, height: self.bounds.height))
            self.node.frame = self.bounds
            self.node.backgroundColor = UIColor.lightGrayColor()
        })
    }
}









