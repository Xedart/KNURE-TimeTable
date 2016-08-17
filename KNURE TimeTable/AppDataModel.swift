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

public struct AppData {
    public static let unixDay = 86400
    public static let pairsStartTime = [1: "7:45", 2: "9:30", 3: "11:15", 4: "13:10", 5: "14:55", 6: "16:40", 7: "18:25", 8: "20:10"]
    public static let pairsEndTime = [1: "9:20", 2: "11:05", 3: "12:50", 4: "14:45", 5: "16:30", 6: "18:15", 7: "20:00", 8: "21:45"]
    public static let defaultScheduleKey = "DefauldScheduleKey"
    public static let savedGroupsShedulesKey = "savedGroupsShedulesKey"
    public static let savedTeachersShedulesKey = "savedTeachersShedulesKey"
    public static let savedAuditoriesShedulesKey = "savedAuditoriesShedulesKey"
    public static let cleanUpMark = "CleanUpMarkKey"
    public static let sharedContainerIdentifier = "group.nureTimeTableSharedData"
    public static let isScheduleUpdated = "isScheduleUpdatedMArk"
    //
    public static let appleButtonDefault = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    public static let initNotification = "initNotification"
    public static let reloadNotification = "ReloadNotification"
    public static let scheduleDidReload = "scheduleDidReload"
    public static let blockNoteTextView = "blockNoteTextView"
    public static let openNoteTextView = "openNoteTextView"
    public static let reloadTableView = "reloadTableViewNotification"
    public static let reloadCollectionView = "reloadCollectionViewNotification"
    
    // some global methods:
    
    public static func getDayOfWeek(_ today:String)-> String {
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
    
    // TODO: get tollowing method out to app from framework:
    
    public static func colorsForPairOfType(_ type: Int?) -> UIColor {
        if type == nil {
            return UIColor.lightGray
        } else if type! >= 0 && type! < 10 {
            return FlatYellowDark()
        } else if type! >= 10 && type! < 20 {
            return FlatMint()
        } else if type! >= 20 && type! < 30 {
            return FlatPurpleDark()
        } else if type! >= 30 && type! < 40 {
            return FlatGray()
        } else if type! >= 40 && type! < 50 {
            return FlatGray()
        } else if type! >= 50 && type! <= 60 {
            return FlatSkyBlue()
        }
        else {
            return UIColor.lightGray
        }
    }
}

public extension Date {
    
    func differenceInDaysWithDate(_ date: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    
    
}




