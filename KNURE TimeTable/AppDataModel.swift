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


