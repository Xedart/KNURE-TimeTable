//
//  SheduleDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/10/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

    // MARK: - Basic data - structures:

//"subject_id":2045902,"start_time":1454910300,"end_time":1454916000,"type":0,"number_pair":1,"auditory":"259","teachers":[4554758],"groups":[4801980 ,4802018 ,4801950 ]}

struct Event {
    var subject_id: String
    var start_time: Int
    var end_time: Int
    var type: Int
    var numberOf_pair: Int
    var auditory: Int
    var teachers: [Int]
    var groups: [Int]
}
//
class Events {
    var events = [Event]()
    init(events: [Event]) {
        self.events = events
    }
    convenience init() {
        self.init(events: [])
    }
    subscript(i: Int) -> Event {
        return events[i]
    }
}

//{"id":5335711,"full_name":"Дейнеко Анастасія Олександрівна","short_name":"Дейнеко А. О."}

struct Teacher {
    var full_name: String
    var short_name: String
}
//
class Teachers {
    var teachers = [String: Teacher]()
    init(teachers: [String: Teacher]) {
        self.teachers = teachers
    }
    convenience init() {
        self.init(teachers: [:])
    }
    subscript(key: String) -> Teacher {
        return teachers[key]!
    }
}

//{"id":1021252,"brief":"МодС","title":"Моделювання систем","hours":[ {"type":10,"val":18,"teachers":[ 412 ]} , {"type":0,"val":30,"teachers":[ 245 ]} ]}

struct Subject {
    var briefTitle: String
    var fullTitle: String
}
//
class Subjects {
    var subjects = [String: Subject]()
    init(subjects: [String: Subject]) {
        self.subjects = subjects
    }
    convenience init() {
        self.init(subjects: [:])
    }
    subscript(key: String) -> Subject {
        return subjects[key]!
    }
}

// {"id":0,"short_name":"Лк","full_name":"Лекція", "id_base":0, "type":"lecture"} 

struct Type {
    var short_name: String
    var full_name: String
    var type: String
}
//
class Types {
    var types = [Int: Type]()
    init(types: [Int: Type]) {
        self.types = types
    }
    convenience init() {
        self.init(types: [:])
    }
    subscript(key: Int) -> Type {
        return types[key]!
    }
}

class Groups {
    var groups = [String: String]()
    init(groups: [String: String]) {
        self.groups = groups
    }
    convenience init() {
        self.init(groups: [:])
    }
    subscript(key: String) -> String {
        return groups[key]!
    }
}

    // MARK: Main data-model class:

class Shedule: NSObject, NSCoding {
    
// Properties:
    var shedule_id: String
    var events = Events()
    var groups = Groups()
    var teachers = Teachers()
    var subjects = Subjects()
    var types = Types()
    
    
// Initialization:
    init(shedule_id: String, events: Events, groups: Groups, teachers: Teachers, subjects: Subjects, types: Types) {
        self.shedule_id = shedule_id
        self.events = events
        self.groups = groups
        self.teachers = teachers
        self.subjects = subjects
        self.types = types
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let shedule_id = aDecoder.decodeObjectForKey(Key.shedule_id) as! String
        let events = aDecoder.decodeObjectForKey(Key.events) as! Events
        let groups = aDecoder.decodeObjectForKey(Key.groups) as! Groups
        let teachers = aDecoder.decodeObjectForKey(Key.teachers) as! Teachers
        let subjects = aDecoder.decodeObjectForKey(Key.subjects) as! Subjects
        let types = aDecoder.decodeObjectForKey(Key.types) as! Types
        self.init(shedule_id: shedule_id, events: events, groups: groups, teachers: teachers, subjects: subjects, types: types)
    }
    
// NSCoding:
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(shedule_id, forKey: Key.shedule_id)
        aCoder.encodeObject(events, forKey: Key.events)
        aCoder.encodeObject(groups, forKey: Key.groups)
        aCoder.encodeObject(teachers, forKey: Key.teachers)
        aCoder.encodeObject(subjects, forKey: Key.subjects)
        aCoder.encodeObject(types, forKey: Key.types)
    }
}

// Keyes - constants:
struct Key {
    static let shedule_id = "shedule_id"
    static let events = "events"
    static let groups = "groups"
    static let teachers = "teachers"
    static let subjects = "subjects"
    static let types = "types"
}


    // MARK: - Methods:

extension Shedule {
// this function return events object composed with today's events:
    func eventsInTime(date: NSDate) -> Events {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        var resultEvents = [Event]()
        for event in events.events {
            if (formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(event.start_time))) == formatter.stringFromDate(date)) {
                resultEvents.append(event)
            }
        }
        return Events(events: resultEvents)
    }
}













