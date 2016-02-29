//
//  CollectionHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    
    let node = ASTextNode()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dispatch_async(dispatch_get_main_queue()) {
            self.addSubview(self.node.view)
        }
    }
    
    func configure(dateStr: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.node.frame = self.bounds
            // text attributes:
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            self.node.attributedString = NSAttributedString(string: "\n\(dateStr)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17), NSForegroundColorAttributeName: FlatGrayDark(), NSParagraphStyleAttributeName: titleParagraphStyle])
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CollectionDecorationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
    }
    
    func configure(height: CGFloat) {
        for i in 0 ..< 8 {
            let timeLabel = UITextView(frame: CGRect(x: 0, y: CGFloat((100 + 1) * (i) + (50 + 1)), width: 55, height: 100))
            timeLabel.text = "\n\(AppData.pairsStartTime[i+1]!)\n\n\(AppData.pairsEndTime[i+1]!)"
            timeLabel.font = UIFont.systemFontOfSize(15)
            timeLabel.editable = false
            timeLabel.textAlignment = .Center
            timeLabel.backgroundColor = self.backgroundColor
            timeLabel.textColor = FlatGrayDark()
            self.addSubview(timeLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class lineView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = FlatGrayDark().colorWithAlphaComponent(0.2)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
















