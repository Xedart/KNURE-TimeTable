//
//  CollectionHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import DataModel
import SVProgressHUD

class CollectionHeaderView: UIView {
    
    // MARK: - Properties:
    
    let cellWidth: CGFloat = 125
    let cellHeight: CGFloat = 50
    let offset: CGFloat = 1
    var delegate: CollectionScheduleViewControllerDelegate!
    let formatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        formatter.dateFormat = "dd.MM"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    func configure(_ schedule: Shedule) {
        
        // frame configuring:
        let contentWidth = (CGFloat(delegate.collectionView!!.numberOfSections) * cellWidth) + (CGFloat(delegate.collectionView!!.numberOfSections) * (offset)) + cellWidth / 2
        self.frame = CGRect(x: 50, y: 0, width: contentWidth, height: cellHeight)
        // delete old subViews:
        for view in self.subviews {
            view.removeFromSuperview()
        }
        //iterate over all days in semester and create label for each:
        for day in 0..<delegate.collectionView!!.numberOfSections {
            
            let dateLabel = UILabel(frame: CGRect(x: (cellWidth + offset) * CGFloat(day), y: 0, width: cellWidth, height: cellHeight))
            
            // text attributes:
            
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .center
            //textString:
            let stringifiedDate = getStringifiedDate(for: day, since: schedule.startDayTime)
            
            var textLabel = stringifiedDate
            let textColor = getTextColor(for: textLabel)
            
            // add week:
            textLabel.append(", \(AppData.getDayOfWeek(getDate(for: day, since: schedule.startDayTime)))")
            // style:
            dateLabel.textAlignment = .center
            dateLabel.textColor = textColor
            dateLabel.font = UIFont.systemFont(ofSize: 17)
            //
            dateLabel.text = textLabel
            self.addSubview(dateLabel)
        }
    }
    
    //MARK: - Helpers:
    
    private func getTextColor(for date: String) -> UIColor {
        
        let todayDate = formatter.string(from: Date())
        if todayDate == date {
            return FlatSkyBlue()
        } else {
            return FlatGrayDark()
        }
    }
    
    private func getStringifiedDate(for day: Int, since firstDay: Int) -> String {
        
        let date = getDate(for: day, since: firstDay)
        return formatter.string(from: date)
    }
    
    private func getDate(for day: Int, since firstDay: Int) -> Date {
        
        let dayLightSavingGap = 3600
        
        return Date(timeInterval: TimeInterval(AppData.unixDay * day), since: Date(timeIntervalSince1970: TimeInterval(firstDay + dayLightSavingGap)))
    }
}

class CollectionDecorationView: UIView {
    
    var cellHeight: CGFloat!
    var extraSpacePlaceholder = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellHeight = 90
            extraSpacePlaceholder = "\n"
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            extraSpacePlaceholder = ""
            cellHeight = 72
        }
    }
    
    func configure(_ height: CGFloat) {
        for i in 0 ..< 8 {
            let timeLabel = UITextView(frame: CGRect(x: 0, y: CGFloat((cellHeight + 1) * CGFloat(i) + (51)), width: 50, height: cellHeight))
            timeLabel.text = "\n\(AppData.pairsStartTime[i+1]!)\n\(extraSpacePlaceholder)\(AppData.pairsEndTime[i+1]!)"
            timeLabel.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
            timeLabel.font = UIFont.systemFont(ofSize: 16)
            timeLabel.isEditable = false
            timeLabel.textAlignment = .center
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
        self.backgroundColor = FlatGrayDark().withAlphaComponent(0.2)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
















