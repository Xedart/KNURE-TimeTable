//
//  SheduleDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/10/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

// data-sctuct for eventsCahce:
public struct EventCache {
    public var events = [Event]()
    public init(events: [Event]) {
        self.events = events
    }
}

public class Shedule: NSObject, NSCoding {
    
    // Static properties (File path ):
    public static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    public static let urlPath = DocumentsDirectory
    
    // MARK: Properties:
    
    public var eventsCache = [String: EventCache]() // cache with data for collectionvView
    public var startDayTime = Int()
    public var endDayTime = Int()
    public var shedule_id: String
    public var scheduleIdentifier: String
    public var lastRefreshDate: String
    public var days = [String: Day]()
    public var groups = [String: String]()
    public var teachers = [String: Teacher]()
    public var subjects = [String: Subject]()
    public var types = [String: NureType]()
    // syncronizable:
    public var notes = [NoteGroup]()
    public var customData = CustomData()
    
    // MARK: Initialization:
    
    //main initializer:
    public init(startDayTime: Int,
                endDayTime: Int,
                shedule_id: String,
                days: [String: Day],
                groups: [String: String],
                teachers: [String: Teacher],
                subjects: [String: Subject],
                types: [String: NureType],
                scheduleIdentifier: String,
                notes: [NoteGroup],
                lastRefreshDate: String,
                customData: CustomData) {
        self.startDayTime = startDayTime
        self.endDayTime = endDayTime
        self.shedule_id = shedule_id
        self.days = days
        self.groups = groups
        self.teachers = teachers
        self.subjects = subjects
        self.types = types
        self.scheduleIdentifier = scheduleIdentifier
        self.notes = notes
        self.lastRefreshDate = lastRefreshDate
        self.customData = customData
        super.init()
    }
    
    // default initializer:
    public convenience override init() {
        self.init(startDayTime: Int(),
                  endDayTime: Int(),
                  shedule_id: String(),
                  days: [:],
                  groups: [:],
                  teachers: [:],
                  subjects: [:],
                  types: [:],
                  scheduleIdentifier: String(),
                  notes: [NoteGroup](),
                  lastRefreshDate: String(),
                  customData: CustomData())
    }
    
    // MARK: - NSCoding:
    
    required convenience public init?(coder aDecoder: NSCoder) {
        
        /* This workaround with decoding Integers is necessary in order to prevent lunch crach after updating app from version 1.0
         */
        
        var startDayTime = Int()
        var endDayTime = Int()
        //startDayTime:
        if aDecoder.decodeObject(forKey: Key.startDayTime) != nil {
            startDayTime = aDecoder.decodeObject(forKey: Key.startDayTime) as! Int
        } else {
            startDayTime = aDecoder.decodeInteger(forKey: Key.startDayTime)
        }
        //endDayTime:
        if aDecoder.decodeObject(forKey: Key.endDayTime) != nil {
            endDayTime = aDecoder.decodeObject(forKey: Key.endDayTime) as! Int
        } else {
            endDayTime = aDecoder.decodeInteger(forKey: Key.endDayTime)
        }
        let shedule_id = aDecoder.decodeObject(forKey: Key.shedule_id) as! String
        let days = aDecoder.decodeObject(forKey: Key.days) as! [String: Day]
        let groups = aDecoder.decodeObject(forKey: Key.groups) as! [String: String]
        let teachers = aDecoder.decodeObject(forKey: Key.teachers) as! [String: Teacher]
        let subjects = aDecoder.decodeObject(forKey: Key.subjects) as! [String: Subject]
        let types = aDecoder.decodeObject(forKey: Key.types) as! [String: NureType]
        //schedule identifier:
        var scheduleIdentifier = aDecoder.decodeObject(forKey: Key.scheduleIdentifier) as? String
        if scheduleIdentifier == nil {
            scheduleIdentifier = ""
        }
        //last refresh:
        var lastRefreshDate = aDecoder.decodeObject(forKey: Key.lastRefreshDateKey) as? String
        if lastRefreshDate == nil {
            lastRefreshDate = AppStrings.notRefreshed
        }
        
        let notes = aDecoder.decodeObject(forKey: Key.notesKey) as! [NoteGroup]
        
        //customData:
        var customData = aDecoder.decodeObject(forKey: Key.customDataKey) as? CustomData
        if customData == nil {
            customData = CustomData()
        }
        
        self.init(startDayTime: startDayTime,
                  endDayTime: endDayTime,
                  shedule_id: shedule_id,
                  days: days,
                  groups: groups,
                  teachers: teachers,
                  subjects: subjects,
                  types: types,
                  scheduleIdentifier: scheduleIdentifier!,
                  notes: notes,
                  lastRefreshDate: lastRefreshDate!,
                  customData: customData!)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(startDayTime, forKey: Key.startDayTime)
        aCoder.encode(endDayTime, forKey: Key.endDayTime)
        aCoder.encode(shedule_id, forKey: Key.shedule_id)
        aCoder.encode(groups, forKey: Key.groups)
        aCoder.encode(teachers, forKey: Key.teachers)
        aCoder.encode(days, forKey: Key.days)
        aCoder.encode(subjects, forKey: Key.subjects)
        aCoder.encode(types, forKey: Key.types)
        aCoder.encode(scheduleIdentifier, forKey: Key.scheduleIdentifier)
        aCoder.encode(notes, forKey: Key.notesKey)
        aCoder.encode(lastRefreshDate, forKey: Key.lastRefreshDateKey)
        aCoder.encode(customData, forKey: Key.customDataKey)
    }
    
    // Keyes - constants:
    struct Key {
        static let startDayTime = "SHStartDayTime"
        static let endDayTime = "SHEndDayTime"
        static let shedule_id = "SHshedule_id"
        static let days = "SHevents"
        static let groups = "SHgroups"
        static let teachers = "SHteachers"
        static let subjects = "SHsubjects"
        static let types = "SHtypes"
        static let scheduleIdentifier = "scheduleIdentifier"
        static let notesKey = "SHNotesKey"
        static let lastRefreshDateKey = "SHlastRefreshDate"
        static let customDataKey = "SHCustomDataKey"
    }
}
