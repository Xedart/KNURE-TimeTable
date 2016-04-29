//
//  TableSheduleHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import ChameleonFramework

class TableSheduleHeader: UILabel {
    
// properties:
    
    let daysTitles = [0: AppStrings.Today,1: AppStrings.Tomorrow]
    
    init(section: Int) {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: AppStrings.LocaleStr)
        formatter.dateFormat = "dd.MM"
        super.init(frame: CGRect())
// header content:
        textColor = FlatGrayDark()
        var textDay = ""
        if daysTitles[section] != nil {
            textDay = daysTitles[section]!
        }
        if section == 0 {
            textColor = FlatSkyBlue()
        }
            text = "\(textDay) \(formatter.stringFromDate(NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section))))"
            text?.appendContentsOf(", \(AppData.getDayOfWeek(formatter.stringFromDate(NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section)))))")
// style:
        backgroundColor = UIColor.whiteColor()
        textAlignment = .Center
        font = UIFont.systemFontOfSize(20)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
