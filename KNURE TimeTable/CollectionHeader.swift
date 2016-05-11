//
//  CollectionHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import ChameleonFramework
import SVProgressHUD

class CollectionHeaderView: UIView {
    
    let cellWidth: CGFloat = 125
    let cellHeight: CGFloat = 50
    let offset: CGFloat = 1
    var delegate: CollectionScheduleViewControllerDelegate!
    let formatter = NSDateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    func configure(schedule: Shedule) {
        
        // frame configuring:
        let contentWidth = (CGFloat(delegate.collectionView!!.numberOfSections()) * cellWidth) + (CGFloat(delegate.collectionView!!.numberOfSections()) * (offset)) + cellWidth / 2
        self.frame = CGRect(x: 55, y: 0, width: contentWidth, height: cellHeight)
        // delete old subViews:
        for view in self.subviews {
            view.removeFromSuperview()
        }
        // 
        for i in 0..<delegate.collectionView!!.numberOfSections() {
            let dateLabel = UILabel(frame: CGRect(x: (cellWidth + offset) * CGFloat(i), y: 0, width: cellWidth, height: cellHeight))
            
            // text attributes:
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd.MM"
            var txtColor = UIColor()
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .Center
            var labelText = formatter.stringFromDate(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * i), sinceDate: NSDate(timeIntervalSince1970: NSTimeInterval(schedule.startDayTime))))
            let todayDate = formatter.stringFromDate(NSDate())
            if todayDate == labelText {
                txtColor = FlatSkyBlue()
            } else {
                txtColor = FlatGrayDark()
            }
            // add week:
            labelText.appendContentsOf(", \(AppData.getDayOfWeek(formatter.stringFromDate(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * i), sinceDate: NSDate(timeIntervalSince1970: NSTimeInterval(schedule.startDayTime))))))")
            // style:
            dateLabel.textAlignment = .Center
            dateLabel.textColor = txtColor
            dateLabel.font = UIFont.systemFontOfSize(17)
            //
            dateLabel.text = labelText
            self.addSubview(dateLabel)
        }
        
    }
}

class CollectionDecorationView: UIView {
    
    var cellHeight: CGFloat!
    var extraSpacePlaceholder = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            cellHeight = 100
            extraSpacePlaceholder = "\n"
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            extraSpacePlaceholder = ""
            cellHeight = 70
        }
    }
    
    func configure(height: CGFloat) {
        for i in 0 ..< 8 {
            let timeLabel = UITextView(frame: CGRect(x: 0, y: CGFloat((cellHeight + 1) * CGFloat(i) + (51)), width: 55, height: cellHeight))
            timeLabel.text = "\n\(AppData.pairsStartTime[i+1]!)\n\(extraSpacePlaceholder)\(AppData.pairsEndTime[i+1]!)"
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
















