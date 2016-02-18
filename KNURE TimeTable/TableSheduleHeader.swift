//
//  TableSheduleHeader.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleHeader: UILabel {
    
// properties:
    
    let daysTitles = [0: "Сьогодні",1: "Завтра"]
    
    init(section: Int) {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ua_UA")
        formatter.dateFormat = "dd.MM"
        super.init(frame: CGRect())
// header content:
        var textDay = ""
        if daysTitles[section] != nil {
            textDay = daysTitles[section]!
        }
            text = "\(textDay) \(formatter.stringFromDate(NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section))))"
            text?.appendContentsOf(", \(getDayOfWeek(formatter.stringFromDate(NSDate(timeIntervalSinceNow: NSTimeInterval(AppData.unixDay * section)))))")
// style:
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        textAlignment = .Center
        font = UIFont.systemFontOfSize(20)
        textColor = FlatGrayDark()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDayOfWeek(today: String) -> String {
        let weekDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд", "Пн"]
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd.mm"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        print(weekDay)
        return weekDays[weekDay]
    }
}
