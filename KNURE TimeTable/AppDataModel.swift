//
//  AppDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

struct AppData {
    static let unixDay = 86400
    static let pairsStartTime = [1: "7:45", 2: "9:30", 3: "11:15", 4: "13:10", 5: "14:55", 6: "16:40", 7: "18:25", 8: "20:10"]
    static let pairsEndTime = [1: "9:20", 2: "11:05", 3: "12:50", 4: "14:45", 5: "16:30", 6: "18:15", 7: "20:00", 8: "21:45"]
    static let defaultScheduleKey = "DefauldScheduleKey"
    static let savedGroupsShedulesKey = "savedGroupsShedulesKey"
    static let savedTeachersShedulesKey = "savedTeachersShedulesKey"
    static let savedAuditoriesShedulesKey = "savedAuditoriesShedulesKey"
    //
    static let appleButtonDefault = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    static let initNotification = "initNotification"
    
    // some global methods:
    
    static func getDayOfWeek(today:String)-> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd.MM"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Сб"
        case 2:
            return "Нд"
        case 3:
            return "Пн"
        case 4:
            return "Вт"
        case 5:
            return "Ср"
        case 6:
            return "Чт"
        case 7:
            return "Пт"
        default:
            print("Error fetching days")
            return "Day"
        }
    }
    
    static func colorsForPairOfType(type: Int?) -> UIColor {
        if type == nil {
        return UIColor.lightGrayColor()
        } else if type >= 0 && type < 10 {
            return FlatYellow()
        } else if type >= 10 && type < 20 {
            return FlatGreen()
        } else if type >= 20 && type < 30 {
            return FlatMagenta()
        } else if type >= 30 && type < 40 {
            return FlatGray()
        } else if type >= 40 && type < 50 {
            return FlatSkyBlue()
        }
        else {
            return UIColor.lightGrayColor()
        }
    }
}

extension NSDate {
    
    func differenceInDaysWithDate(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let date1 = calendar.startOfDayForDate(self)
        let date2 = calendar.startOfDayForDate(date)
        
        let components = calendar.components(.Day, fromDate: date1, toDate: date2, options: [])
        return components.day
    }
}




