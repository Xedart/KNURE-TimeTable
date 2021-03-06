//
//  AppDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

  // Container structure for app global functionality:

public struct AppData {
    
    // MARK: - Global app-specific constants:
    
    public static let unixDay = 86400
    public static let pairTime = 5700
    public static let pairsStartTime = [1: "7:45", 2: "9:30", 3: "11:15", 4: "13:10", 5: "14:55", 6: "16:40", 7: "18:25", 8: "20:10"]
    public static let pairsEndTime = [1: "9:20", 2: "11:05", 3: "12:50", 4: "14:45", 5: "16:30", 6: "18:15", 7: "20:00", 8: "21:45"]
    
    /// Returns the number of seconds from 00:00 to the start of the pair.
    public static func secondsFromDayBeginToPair(numberOfPair: Int?) -> Int {
        
        if numberOfPair == nil {
            return 0
        }
        
        switch numberOfPair! {
        case 1:
            return 27900
        case 2:
            return 34200
        case 3:
            return 40500
        case 4:
            return 47400
        case 5:
            return 53700
        case 6:
            return 60000
        case 7:
            return 66300
        case 8:
            return 72600
        default:
            return 0
        }
    }
    
    // MARK: - UserDefaults' keys:
    
    public static let defaultScheduleKey = "DefauldScheduleKey"
    public static let savedGroupsShedulesKey = "savedGroupsShedulesKey"
    public static let savedTeachersShedulesKey = "savedTeachersShedulesKey"
    public static let savedAuditoriesShedulesKey = "savedAuditoriesShedulesKey"
    public static let cleanUpMark = "CleanUpMarkKey"
    public static let sharedContainerIdentifier = "group.nureTimeTableSharedData"
    public static let isScheduleUpdated = "isScheduleUpdatedMArk"
    public static let shouldSuncNotesKey = "shouldSyncNotesKey"
    public static let shouldSyncEventsKey = "ShouldSyncEventsKey"
    public static let apnEnabledSchedulesKey = "APNEnabledSchedulesKey"
    public static let apnDisabledSchedulesKey = "APNDisabledSchedulesKey"
    public static let initialLunchKey = "APNDInitialLunchKey"
    
    // MARK: - Notifications' names:
    
    public static let initNotification = "initNotification"
    public static let reloadNotification = "ReloadNotification"
    public static let scheduleDidReload = "scheduleDidReload"
    public static let blockNoteTextView = "blockNoteTextView"
    public static let openNoteTextView = "openNoteTextView"
    public static let reloadTableView = "reloadTableViewNotification"
    public static let reloadCollectionView = "reloadCollectionViewNotification"
    
    // MARK: - Other:
    
    public static let appleButtonDefault = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    
    // some global methods:
    
    public static func getDayOfWeek(_ todayDate: Date) -> String {
        
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = myCalendar.dateComponents([.weekday], from: todayDate)
        
        let weekDay = myComponents.weekday
        switch weekDay! {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
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
            return NureYellow()
        } else if type! >= 10 && type! < 20 {
            return NureGreen()
        } else if type! >= 20 && type! < 30 {
            return NurePurple()
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
