//
//  AppDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
//import ChameleonFramework

  // Container structure for app global functionality:

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
    static let reloadNotification = "ReloadNotification"
    static let scheduleDidReload = "scheduleDidReload"
    static let blockNoteTextView = "blockNoteTextView"
    static let openNoteTextView = "openNoteTextView"
    static let reloadTableView = "reloadTableViewNotification"
    static let reloadCollectionView = "reloadCollectionViewNotification"
    
    // some global methods:
    
    static func getDayOfWeek(_ today:String)-> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = myCalendar.dateComponents([.weekday], from: todayDate)
        
        
        
        let weekDay = myComponents.weekday
        switch weekDay! {
        case 1:
            return "Сб"
        case 2:
            return "Вс"
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
    
    static func colorsForPairOfType(_ type: Int?) -> UIColor {
        if type == nil {
        return UIColor.lightGray
        } else if type >= 0 && type < 10 {
            return FlatYellowDark()
        } else if type >= 10 && type < 20 {
            return FlatMint()
        } else if type >= 20 && type < 30 {
            return FlatPurpleDark()
        } else if type >= 30 && type < 40 {
            return FlatGray()
        } else if type >= 40 && type < 50 {
            return FlatGray()
        } else if type >= 50 && type <= 60 {
            return FlatSkyBlue()
        }
        else {
            return UIColor.lightGray
        }
    }
}

extension Date {
    
    func differenceInDaysWithDate(_ date: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
    }
}




