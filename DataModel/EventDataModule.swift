//
//  EventDataModule.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

//"subject_id":2045902,"start_time":1454910300,"end_time":1454916000,"type":0,"number_pair":1,"auditory":"259","teachers":[4554758],"groups":[4801980 ,4802018 ,4801950 ]}

public class Event: NSObject, NSCoding  {
    public var subject_id: String
    public var start_time: Int
    public var end_time: Int
    public var type: String
    public var numberOf_pair: Int
    public var auditory: String
    public var teachers: [Int]
    public var groups: [Int]
    public var isCustom: Bool
    public var alarmPreference: Int
    public var calendarEventId: String
    public var getEventId: String {
        get {
            return "\(subject_id)\(start_time)" // composed event token
        }
    }
    
    // Initialiation:
    
    public init(jsonData: JSON) {
        self.subject_id = jsonData["subject_id"].stringValue
        self.start_time = jsonData["start_time"].intValue
        self.end_time = jsonData["end_time"].intValue
        self.type = jsonData["type"].stringValue
        self.numberOf_pair = jsonData["number_pair"].intValue
        self.auditory = jsonData["auditory"].stringValue
        var teachers = [Int]()
        for jsTeacher in jsonData["teachers"].arrayValue {
            teachers.append(jsTeacher.intValue)
        }
        var groups = [Int]()
        for jsGroup in jsonData["groups"].arrayValue {
            groups.append(jsGroup.intValue)
        }
        self.teachers = teachers
        self.groups = groups
        self.isCustom = Bool()
        self.calendarEventId = String()
        self.alarmPreference = alarmTime.fifteenMinutes.rawValue
    }
    
    public init(subject_id: String,
                start_time: Int,
                end_time: Int,
                type: String,
                numberOfPair: Int,
                auditory: String,
                teachers: [Int],
                groups: [Int],
                isCustom: Bool,
                alarmTime: Int,
                calendarEventId: String) {
        self.subject_id = subject_id
        self.start_time = start_time
        self.end_time = end_time
        self.type = type
        self.numberOf_pair = numberOfPair
        self.auditory = auditory
        self.teachers = teachers
        self.groups = groups
        self.isCustom = isCustom
        self.alarmPreference = alarmTime
        self.calendarEventId = calendarEventId
    }
    
    public convenience override init() {
        self.init(subject_id: String(),
                  start_time: Int(),
                  end_time: Int(),
                  type: String(),
                  numberOfPair: Int(),
                  auditory: String(),
                  teachers: [Int](),
                  groups: [Int](),
                  isCustom: Bool(),
                  alarmTime: alarmTime.fifteenMinutes.rawValue,
                  calendarEventId: String()
        )
    }
    
    // NCCoding:
    required convenience public init?(coder aDecoder: NSCoder) {
        
        /* This workaround with decoding Integers is necessary in order to prevent lunch crash after updating app from version 1.0
         */
        var start_time = Int()
        var end_time = Int()
        var numberOfPair = Int()
        
        //start_time:
        if aDecoder.decodeObject(forKey: Key.start_time) != nil {
            start_time = aDecoder.decodeObject(forKey: Key.start_time) as! Int
        } else {
            start_time = aDecoder.decodeInteger(forKey: Key.start_time)
        }
        
        //end_time:
        if aDecoder.decodeObject(forKey: Key.end_time) != nil {
            end_time = aDecoder.decodeObject(forKey: Key.end_time) as! Int
        } else {
            end_time = aDecoder.decodeInteger(forKey: Key.end_time)
        }
        
        //numberOfPair:
        if aDecoder.decodeObject(forKey: Key.numberOFPair) != nil {
            numberOfPair = aDecoder.decodeObject(forKey: Key.numberOFPair) as! Int
        } else {
            numberOfPair = aDecoder.decodeInteger(forKey: Key.numberOFPair)
        }
        //
        let subject_id = aDecoder.decodeObject(forKey: Key.subject_id) as! String
        let type = aDecoder.decodeObject(forKey: Key.type) as! String
        let auditory = aDecoder.decodeObject(forKey: Key.auditory) as! String
        let teachers = aDecoder.decodeObject(forKey: Key.teachers) as! [Int]
        let groups = aDecoder.decodeObject(forKey: Key.groups) as! [Int]
        let isCustom = aDecoder.decodeBool(forKey: Key.isCustomKey)
        let alarmPreference = aDecoder.decodeInteger(forKey: Key.alarmPreferenceKey)
        let calendarEventId = aDecoder.decodeObject(forKey: Key.calendarEventIdKey) as! String
        
        self.init(subject_id: subject_id,
                  start_time: start_time,
                  end_time: end_time,
                  type: type,
                  numberOfPair: numberOfPair,
                  auditory: auditory,
                  teachers: teachers,
                  groups: groups,
                  isCustom: isCustom,
                  alarmTime: alarmPreference,
                  calendarEventId: calendarEventId)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(subject_id, forKey: Key.subject_id)
        aCoder.encode(start_time, forKey: Key.start_time)
        aCoder.encode(end_time, forKey: Key.end_time)
        aCoder.encode(type, forKey: Key.type)
        aCoder.encode(numberOf_pair, forKey: Key.numberOFPair)
        aCoder.encode(auditory, forKey: Key.auditory)
        aCoder.encode(teachers, forKey: Key.teachers)
        aCoder.encode(groups, forKey: Key.groups)
        aCoder.encode(isCustom, forKey: Key.isCustomKey)
        aCoder.encode(alarmPreference, forKey: Key.alarmPreferenceKey)
        aCoder.encode(calendarEventId, forKey: Key.calendarEventIdKey)
    }
    
    struct Key {
        static let subject_id = "EVSubjectId"
        static let start_time = "EVStartTime"
        static let end_time = "EVEndTime"
        static let type = "EVType"
        static let numberOFPair = "EVNUmberOFpairs"
        static let auditory = "EVAuditory"
        static let teachers = "EVTeachers"
        static let groups = "EVGroups"
        static let isCustomKey = "EXISCustomKey"
        static let alarmPreferenceKey = "EVAlarmPreferenceKey"
        static let calendarEventIdKey = "EVCalendarEventIdKey"
    }
}


// Wrapper class for incapsulating events within one day:

public class Day: NSObject, NSCoding {
    public var events: [Event]
    public init(events: [Event]) {
        self.events = events
    }
    override public init() {
        self.events = [Event]()
    }
    // NCCoding:
    required convenience public init?(coder aDecoder: NSCoder) {
        let events = aDecoder.decodeObject(forKey: Key.events) as! [Event]
        self.init(events: events)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(events, forKey: Key.events)
    }
    struct Key {
        static let events = "DAYEvents"
    }
}
