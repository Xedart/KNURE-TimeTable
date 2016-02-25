//
//  SheduleDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/10/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

    // MARK: - Basic data-classes:

//"subject_id":2045902,"start_time":1454910300,"end_time":1454916000,"type":0,"number_pair":1,"auditory":"259","teachers":[4554758],"groups":[4801980 ,4802018 ,4801950 ]}

class Event: NSObject, NSCoding  {
    var subject_id: String
    var start_time: Int
    var end_time: Int
    var type: String
    var numberOf_pair: Int
    var auditory: String
    var teachers: [Int]
    var groups: [Int]
//initialiation:
    init(subject_id: String, start_time: Int, end_time: Int, type: String, numberOfPair: Int, auditory: String, teachers: [Int], groups: [Int]) {
        self.subject_id = subject_id
        self.start_time = start_time
        self.end_time = end_time
        self.type = type
        self.numberOf_pair = numberOfPair
        self.auditory = auditory
        self.teachers = teachers
        self.groups = groups
    }
    convenience override init() {
        self.init(subject_id: String(), start_time: Int(), end_time: Int(), type: String(), numberOfPair: Int(), auditory: String(), teachers: [Int](), groups: [Int]())
    }
// NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let subject_id = aDecoder.decodeObjectForKey(Key.subject_id) as! String
        let start_time = aDecoder.decodeObjectForKey(Key.start_time) as! Int
        let end_time = aDecoder.decodeObjectForKey(Key.end_time) as! Int
        let type = aDecoder.decodeObjectForKey(Key.type) as! String
        let numberOfPair = aDecoder.decodeObjectForKey(Key.numberOFPair) as! Int
        let auditory = aDecoder.decodeObjectForKey(Key.auditory) as! String
        let teachers = aDecoder.decodeObjectForKey(Key.teachers) as! [Int]
        let groups = aDecoder.decodeObjectForKey(Key.groups) as! [Int]
        self.init(subject_id: subject_id, start_time: start_time, end_time: end_time, type: type, numberOfPair: numberOfPair, auditory: auditory, teachers: teachers, groups: groups)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(subject_id, forKey: Key.subject_id)
        aCoder.encodeObject(start_time, forKey: Key.start_time)
        aCoder.encodeObject(end_time, forKey: Key.end_time)
        aCoder.encodeObject(type, forKey: Key.type)
        aCoder.encodeObject(numberOf_pair, forKey: Key.numberOFPair)
        aCoder.encodeObject(auditory, forKey: Key.auditory)
        aCoder.encodeObject(teachers, forKey: Key.teachers)
        aCoder.encodeObject(groups, forKey: Key.groups)
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
    }
}

// Wrapper class for incapsulating events within one day:

class Day: NSObject, NSCoding {
    var events: [Event]
    init(events: [Event]) {
        self.events = events
    }
    override init() {
        self.events = [Event]()
    }
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let events = aDecoder.decodeObjectForKey(Key.events) as! [Event]
        self.init(events: events)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(events, forKey: Key.events)
    }
    struct Key {
        static let events = "DAYEvents"
    }
}

//{"id":5335711,"full_name":"Дейнеко Анастасія Олександрівна","short_name":"Дейнеко А. О."}

class Teacher: NSObject, NSCoding {
    var full_name: String
    var short_name: String
    init(full_name: String, short_name: String) {
        self.full_name = full_name
        self.short_name = short_name
    }
    convenience override init() {
        self.init(full_name: String(), short_name: String())
    }
// NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let full_name = aDecoder.decodeObjectForKey(Key.fullName) as! String
        let short_name = aDecoder.decodeObjectForKey(Key.shortName) as! String
        self.init(full_name: full_name, short_name: short_name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(full_name, forKey: Key.fullName)
        aCoder.encodeObject(short_name, forKey: Key.shortName)
    }
    struct Key {
        static let fullName = "TCfullName"
        static let shortName = "TCshortName"
    }
}

//{"id":1021252,"brief":"МодС","title":"Моделювання систем","hours":[ {"type":10,"val":18,"teachers":[ 412 ]} , {"type":0,"val":30,"teachers":[ 245 ]} ]}

class Subject: NSObject, NSCoding {
    var briefTitle: String
    var fullTitle: String
    init(briefTitle: String, fullTitle: String) {
        self.briefTitle = briefTitle
        self.fullTitle = fullTitle
    }
    convenience override init() {
        self.init(briefTitle: String(), fullTitle: String())
    }
// NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let briefTitle = aDecoder.decodeObjectForKey(Key.briefTitle) as! String
        let fullTitle = aDecoder.decodeObjectForKey(Key.fullTitle) as! String
        self.init(briefTitle: briefTitle, fullTitle: fullTitle)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(briefTitle, forKey: Key.briefTitle)
        aCoder.encodeObject(fullTitle, forKey: Key.fullTitle)
    }
    struct Key {
        static let briefTitle = "SBBriefTitle"
        static let fullTitle = "SBFullTitle"
    }
}

// {"id":0,"short_name":"Лк","full_name":"Лекція", "id_base":0, "type":"lecture"}

class NureType: NSObject, NSCoding {
    var short_name: String
    var full_name: String
    init(short_name: String, full_name: String) {
        self.short_name = short_name
        self.full_name = full_name
    }
    convenience override init() {
        self.init(short_name: String(), full_name: String())
    }
// NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let short_name = aDecoder.decodeObjectForKey(Key.short_name) as! String
        let full_name = aDecoder.decodeObjectForKey(Key.full_name) as! String
        self.init(short_name: short_name, full_name: full_name)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(short_name, forKey: Key.short_name)
        aCoder.encodeObject(full_name, forKey: Key.full_name)
    }
    struct Key {
        static let short_name = "TPShortName"
        static let full_name = "TPFullName"
    }
}

//                                   //
    // MARK: Main data-model class:

//                                   //

class Shedule: NSObject, NSCoding {
    
// Static properties (File path ):
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    let urlPath = DocumentsDirectory
    
// Properties:
    var startDayTime = Int()
    var endDayTime = Int()
    var shedule_id: String
    var days = [String: Day]()
    var groups = [String: String]()
    var teachers = [String: Teacher]()
    var subjects = [String: Subject]()
    var types = [String: NureType]()
    
    
// Initialization:
    init(startDayTime: Int, endDayTime: Int, shedule_id: String, days: [String: Day], groups: [String: String], teachers: [String: Teacher], subjects: [String: Subject], types: [String: NureType]) {
        self.startDayTime = startDayTime
        self.endDayTime = endDayTime
        self.shedule_id = shedule_id
        self.days = days
        self.groups = groups
        self.teachers = teachers
        self.subjects = subjects
        self.types = types
        super.init()
    }
    
    convenience override init() {
        self.init(startDayTime: Int(), endDayTime: Int(), shedule_id: String(), days: [:], groups: [:], teachers: [:], subjects: [:], types: [:])
    }
    
    // MARK: - NSCoding:
    
    required convenience init?(coder aDecoder: NSCoder) {
        let startDayTime = aDecoder.decodeObjectForKey(Key.startDayTime) as! Int
        let endDayTime = aDecoder.decodeObjectForKey(Key.endDayTime) as! Int
        let shedule_id = aDecoder.decodeObjectForKey(Key.shedule_id) as! String
        let days = aDecoder.decodeObjectForKey(Key.days) as! [String: Day]
        let groups = aDecoder.decodeObjectForKey(Key.groups) as! [String: String]
        let teachers = aDecoder.decodeObjectForKey(Key.teachers) as! [String: Teacher]
        let subjects = aDecoder.decodeObjectForKey(Key.subjects) as! [String: Subject]
        let types = aDecoder.decodeObjectForKey(Key.types) as! [String: NureType]
        self.init(startDayTime: startDayTime, endDayTime: endDayTime, shedule_id: shedule_id, days: days, groups: groups, teachers: teachers, subjects: subjects, types: types)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startDayTime, forKey: Key.startDayTime)
        aCoder.encodeObject(endDayTime, forKey: Key.endDayTime)
        aCoder.encodeObject(shedule_id, forKey: Key.shedule_id)
        aCoder.encodeObject(groups, forKey: Key.groups)
        aCoder.encodeObject(teachers, forKey: Key.teachers)
        aCoder.encodeObject(days, forKey: Key.days)
        aCoder.encodeObject(subjects, forKey: Key.subjects)
        aCoder.encodeObject(types, forKey: Key.types)
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
    }
}
    // MARK: - Methods:

extension Shedule {
    
    func eventsInDay(date: NSDate) -> [Event] {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let dayStrId = formatter.stringFromDate(date)
        if let resultEvents = days[dayStrId]?.events {
            return resultEvents
        } else {
            return [Event]()
        }
    }
}





