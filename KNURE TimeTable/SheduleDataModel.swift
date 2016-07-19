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
    var isCustom: Bool
    var getEventId: String {
        get {
            return "\(subject_id)\(start_time)" // composed event token
        }
    }
    
    //initialiation:
    init(subject_id: String, start_time: Int, end_time: Int, type: String, numberOfPair: Int, auditory: String, teachers: [Int], groups: [Int], isCustom: Bool) {
        self.subject_id = subject_id
        self.start_time = start_time
        self.end_time = end_time
        self.type = type
        self.numberOf_pair = numberOfPair
        self.auditory = auditory
        self.teachers = teachers
        self.groups = groups
        self.isCustom = isCustom
    }
    convenience override init() {
        self.init(subject_id: String(), start_time: Int(), end_time: Int(), type: String(), numberOfPair: Int(), auditory: String(), teachers: [Int](), groups: [Int](), isCustom: Bool())
    }
    
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        
        /* This workaround with decoding Integers is necessary in order to prevent lunch crach after updating app from version 1.0
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
        self.init(subject_id: subject_id, start_time: start_time, end_time: end_time, type: type, numberOfPair: numberOfPair, auditory: auditory, teachers: teachers, groups: groups, isCustom: isCustom)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(subject_id, forKey: Key.subject_id)
        aCoder.encode(start_time, forKey: Key.start_time)
        aCoder.encode(end_time, forKey: Key.end_time)
        aCoder.encode(type, forKey: Key.type)
        aCoder.encode(numberOf_pair, forKey: Key.numberOFPair)
        aCoder.encode(auditory, forKey: Key.auditory)
        aCoder.encode(teachers, forKey: Key.teachers)
        aCoder.encode(groups, forKey: Key.groups)
        aCoder.encode(isCustom, forKey: Key.isCustomKey)
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
        let events = aDecoder.decodeObject(forKey: Key.events) as! [Event]
        self.init(events: events)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(events, forKey: Key.events)
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
        let full_name = aDecoder.decodeObject(forKey: Key.fullName) as! String
        let short_name = aDecoder.decodeObject(forKey: Key.shortName) as! String
        self.init(full_name: full_name, short_name: short_name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(full_name, forKey: Key.fullName)
        aCoder.encode(short_name, forKey: Key.shortName)
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
        let briefTitle = aDecoder.decodeObject(forKey: Key.briefTitle) as! String
        let fullTitle = aDecoder.decodeObject(forKey: Key.fullTitle) as! String
        self.init(briefTitle: briefTitle, fullTitle: fullTitle)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(briefTitle, forKey: Key.briefTitle)
        aCoder.encode(fullTitle, forKey: Key.fullTitle)
    }
    struct Key {
        static let briefTitle = "SBBriefTitle"
        static let fullTitle = "SBFullTitle"
    }
}

// {"id":0,"short_name":"Лк","full_name":"Лекція", "id_base":0, "type":"lecture"}

class NureType: NSObject, NSCoding {
    var id: String
    var short_name: String
    var full_name: String
    init(short_name: String, full_name: String, id: String) {
        self.id = id
        self.short_name = short_name
        self.full_name = full_name
    }
    convenience override init() {
        self.init(short_name: String(), full_name: String(), id: String())
    }
    
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let short_name = aDecoder.decodeObject(forKey: Key.short_name) as! String
        let full_name = aDecoder.decodeObject(forKey: Key.full_name) as! String
        let id = aDecoder.decodeObject(forKey: Key.id_key) as! String
        self.init(short_name: short_name, full_name: full_name, id: id)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(short_name, forKey: Key.short_name)
        aCoder.encode(full_name, forKey: Key.full_name)
        aCoder.encode(id, forKey: Key.id_key)
    }
    struct Key {
        static let short_name = "TPShortName"
        static let full_name = "TPFullName"
        static let id_key = "TPId"
    }
}

// Notes:

class Note: NSObject, NSCoding {
    let idToken: String
    let coupledEventTitle: String
    let creationDate: String
    var updateDate: String
    var text: String
    
    init(idToken: String, coupledEventTitle: String, creationDate: String, updatedDate: String, text: String) {
        self.idToken = idToken
        self.coupledEventTitle = coupledEventTitle
        self.creationDate = creationDate
        self.updateDate = updatedDate
        self.text = text
    }
    
    convenience override init() {
        self.init(idToken: String(), coupledEventTitle: String(), creationDate: String(), updatedDate: String(), text: String())
    }
    
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let idToken = aDecoder.decodeObject(forKey: Key.idTokenKey) as! String
        let coupledEventTitle = aDecoder.decodeObject(forKey: Key.coupledEventTitleKey) as! String
        let creationDate = aDecoder.decodeObject(forKey: Key.creationDateKey) as! String
        let updatedDate = aDecoder.decodeObject(forKey: Key.updatedDateKey) as! String
        let text = aDecoder.decodeObject(forKey: Key.textKey) as! String
        self.init(idToken: idToken, coupledEventTitle: coupledEventTitle, creationDate: creationDate, updatedDate: updatedDate, text: text)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.idToken, forKey: Key.idTokenKey)
        aCoder.encode(self.coupledEventTitle, forKey: Key.coupledEventTitleKey)
        aCoder.encode(self.creationDate, forKey: Key.creationDateKey)
        aCoder.encode(self.updateDate, forKey: Key.updatedDateKey)
        aCoder.encode(self.text, forKey: Key.textKey)
    }
    
    struct Key {
        static let idTokenKey = "NTIDTokenKey"
        static let coupledEventTitleKey = "NTcoupledEventTitle"
        static let creationDateKey = "NTcreationDate"
        static let updatedDateKey = "NTupdatedDate"
        static let textKey = "NTTextKEy"
    }
}

class NoteGroup: NSObject, NSCoding {
    var groupTitle: String
    var notes: [Note]
    
    init(groupTitle: String, notes: [Note]) {
        self.groupTitle = groupTitle
        self.notes = notes
    }
    
    convenience override init() {
        self.init(groupTitle: "", notes: [Note]())
    }
    
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        let groupTitle = aDecoder.decodeObject(forKey: Key.groupTitleKey) as! String
        let notes = aDecoder.decodeObject(forKey: Key.notesKey) as! [Note]
        self.init(groupTitle: groupTitle, notes: notes)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.groupTitle, forKey: Key.groupTitleKey)
        aCoder.encode(self.notes, forKey: Key.notesKey)
    }
    
    struct Key {
        static let groupTitleKey = "NTGroupTitleKey"
        static let notesKey = "NTNotesKey"
    }
}

/// All user defined ( custom ) data are saved in this class
class CustomData: NSObject, NSCoding {
    
    // Properties:
    var groups = [String: String]()
    var teachers = [String: Teacher]()
    var subjects = [String: Subject]()
    var types = [String: NureType]()
    var events = [Event]()
    
    // initialization:
    init(groups: [String: String], teachers: [String: Teacher], subjects: [String: Subject], types: [String: NureType], events: [Event]) {
        self.groups = groups
        self.teachers = teachers
        self.subjects = subjects
        self.types = types
        self.events = events
    }
    
    convenience override init() {
        self.init(groups: [:], teachers: [:], subjects: [:], types: [:], events: [])
    }
    
    // NCCoding:
    required convenience init?(coder aDecoder: NSCoder) {
        // groups:
        var groups = aDecoder.decodeObject(forKey: Key.groupsKey) as? [String: String]
        if groups == nil {
            groups = [String: String]()
        }
        // teachers:
        var teachers = aDecoder.decodeObject(forKey: Key.teachersKey) as? [String: Teacher]
        if teachers == nil {
            teachers = [String: Teacher]()
        }
        //subjects:
        var subjects = aDecoder.decodeObject(forKey: Key.subjectsKey) as? [String: Subject]
        if subjects == nil {
            subjects = [String: Subject]()
        }
        //types:
        var types = aDecoder.decodeObject(forKey: Key.typesKey) as? [String: NureType]
        if types == nil {
            types = [String: NureType]()
        }
        //events:
        var events = aDecoder.decodeObject(forKey: Key.eventsKey) as? [Event]
        if events == nil {
            events = [Event]()
        }
        
        self.init(groups: groups!, teachers: teachers!, subjects: subjects!, types: types!, events: events!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groups, forKey: Key.groupsKey)
        aCoder.encode(teachers, forKey: Key.teachersKey)
        aCoder.encode(subjects, forKey: Key.subjectsKey)
        aCoder.encode(types, forKey: Key.typesKey)
        aCoder.encode(events, forKey: Key.eventsKey)
    }
    
    struct Key {
        static let groupsKey = "CUSGroupsKey"
        static let teachersKey = "CUSTeachersKey"
        static let subjectsKey = "CUSSubjectsKey"
        static let typesKey = "CUSSTypesKeyKey"
        static let eventsKey = "CUSEventsKey"
    }
}

// data-sctuct for eventsCahce:
struct EventCache {
    var events = [Event]()
    init(events: [Event]) {
        self.events = events
    }
}

//----------------------------------------------------------------------------------------//
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                      *  MARK: Main data-model class  *                                 //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//----------------------------------------------------------------------------------------//

class Shedule: NSObject, NSCoding {
    
    // Static properties (File path ):
    static let DocumentsDirectory = FileManager().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!
    let urlPath = DocumentsDirectory
    
    // MARK: Properties:
    
    var eventsCache = [String: EventCache]() // cache with data for collectionvView
    var startDayTime = Int()
    var endDayTime = Int()
    var shedule_id: String
    var scheduleIdentifier: String
    var lastRefreshDate: String
    var days = [String: Day]()
    var groups = [String: String]()
    var teachers = [String: Teacher]()
    var subjects = [String: Subject]()
    var types = [String: NureType]()
    // syncronizable:
    var notes = [NoteGroup]()
    var customData = CustomData()
    
    // MARK: Initialization:
    
    //main initializer:
    init(startDayTime: Int, endDayTime: Int, shedule_id: String, days: [String: Day], groups: [String: String], teachers: [String: Teacher], subjects: [String: Subject], types: [String: NureType], scheduleIdentifier: String, notes: [NoteGroup], lastRefreshDate: String, customData: CustomData) {
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
    convenience override init() {
        self.init(startDayTime: Int(), endDayTime: Int(), shedule_id: String(), days: [:], groups: [:], teachers: [:], subjects: [:], types: [:], scheduleIdentifier: String(), notes: [NoteGroup](), lastRefreshDate: String(), customData: CustomData())
    }
    
    // MARK: - NSCoding:
    
    required convenience init?(coder aDecoder: NSCoder) {
        
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
        
        self.init(startDayTime: startDayTime, endDayTime: endDayTime, shedule_id: shedule_id, days: days, groups: groups, teachers: teachers, subjects: subjects, types: types, scheduleIdentifier: scheduleIdentifier!, notes: notes, lastRefreshDate: lastRefreshDate!, customData: customData!)
    }
    
    func encode(with aCoder: NSCoder) {
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

// ----------------------------------------------------------------------------------------

    // MARK: - Methods: (Data logic)

// ----------------------------------------------------------------------------------------
extension Shedule {
    
    func performCache() {
        eventsCache.removeAll()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let firstEventDay = Date(timeIntervalSince1970: TimeInterval(self.startDayTime))
        for section in 0 ..< self.numberOfDaysInSemester() {
            
            for row in 0..<self.numberOfPairsInDay() {
                let events = self.eventInDayWithNumberOfPair(Date(timeInterval: TimeInterval(AppData.unixDay * section), since: firstEventDay), numberOFPair: row + 1)
                self.eventsCache["\(section)\(row)"] = EventCache(events: events)
            }
        }
    }
    
    func numberOfDaysInSemester() -> Int {
        if self.shedule_id.isEmpty {
            return 0
        }
        let firstEventDay = Date(timeIntervalSince1970: TimeInterval(self.startDayTime))
        let lastDay = Date(timeIntervalSince1970: TimeInterval(self.endDayTime))
        let numberOfdays = firstEventDay.differenceInDaysWithDate(lastDay) + 1
        return numberOfdays == 1 ? 0 : numberOfdays
    }
    
    func numberOfPairsInDay() -> Int {
        if self.shedule_id.isEmpty {
            return 0
        }
        return 8
    }
    
    func eventsInDay(_ date: Date) -> [Event] {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dayStrId = formatter.string(from: date)
        if let resultEvents = days[dayStrId]?.events {
            return resultEvents
        } else {
            return [Event]()
        }
    }
    
    func eventInDayWithNumberOfPair(_ day: Date, numberOFPair: Int) -> [Event] {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dayStrId = formatter.string(from: day)
        if let events = days[dayStrId]?.events {
        var resultEvents = [Event]()
        for event in events {
            if numberOFPair == event.numberOf_pair {
                resultEvents.append(event)
            }
          }
            return resultEvents
        } else {
            return [Event]()
        }
    }
    
    func getNoteWithTokenId(_ tokenId: String) -> Note? {
        for group in self.notes {
            for note in group.notes {
                if note.idToken == tokenId {
                    return note
                }
            }
        }
        return nil
    }
    
    func deleteNoteWithId(_ noteId: String) -> Bool {
        var groupeIndex = 0
        for groupe in self.notes {
            var noteIndex = 0
            for note in groupe.notes {
                if note.idToken == noteId {
                self.notes[groupeIndex].notes.remove(at: noteIndex)
                    if self.notes[groupeIndex].notes.isEmpty {
                        notes.remove(at: groupeIndex)
                        return true
                    }
                    return false
                }
                noteIndex += 1
            }
            groupeIndex += 1
        }
        return false
    }
    
    func addNewNote(_ note: Note) {
        for groupe in self.notes {
            if groupe.groupTitle == note.coupledEventTitle {
                groupe.notes.append(note)
                return
            }
        }
        // create new group:
        let newGroup = NoteGroup(groupTitle: note.coupledEventTitle, notes: [note])
        self.notes.append(newGroup)
    }
    
    func insertEvent(_ event: Event, in day: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        // check for persistance of day:
        if days[formatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.start_time)))] == nil {
            //add a day to schedule if needed:
            days[formatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.start_time)))] = Day(events: [event])
            // change start time of shcedule if needed:
            if event.start_time < self.startDayTime {
                self.startDayTime = event.start_time
            }
            // change end time of schedule if needed:
            if event.end_time > self.endDayTime {
                self.endDayTime = event.end_time
            }
            return
        }
        
        let events = days[formatter.string(from: day)]!.events
        // push stack below
        for i in 0..<events.count {
            if events[i].numberOf_pair > event.numberOf_pair {
                days[formatter.string(from: day)]!.events.insert(event, at: i)
                return
            }
        }
        // push stack below
        for i in 0..<events.count {
            if events[i].numberOf_pair == event.numberOf_pair {
                days[formatter.string(from: day)]!.events.insert(event, at: i)
                 return
            }
        }
        // append on top of stack:
        days[formatter.string(from: day)]!.events.append(event)
    }
    
    func mergeData() {
        // merge events:
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        for event in self.customData.events {
            self.insertEvent(event, in: Date(timeIntervalSince1970: TimeInterval(event.start_time)))
        }
        // merge groups:
        for (key, value) in self.customData.groups {
            self.groups[key] = value
        }
        // merge teachers:
        for (key, value) in self.customData.teachers {
            self.teachers[key] = value
        }
        // merge subjects:
        for (key, value) in self.customData.subjects {
            self.subjects[key] = value
        }
        // merge types:
        for (key, value) in self.customData.types {
            self.types[key] = value
        }
    }
    
     func saveShedule() {
    
        let save = NSKeyedArchiver.archiveRootObject(self, toFile: "\(Shedule().urlPath.path!)/\(self.shedule_id)")
        if !save {
            print("Error when saving")
        }
    }
}
