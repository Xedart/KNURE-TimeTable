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

//{"id":5335711,"full_name":"Дейнеко Анастасія Олександрівна","short_name":"Дейнеко А. О."}

public class Teacher: NSObject, NSCoding {
    public var full_name: String
    public var short_name: String
    public init(full_name: String, short_name: String) {
        self.full_name = full_name
        self.short_name = short_name
    }
    convenience override public init() {
        self.init(full_name: String(), short_name: String())
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        let full_name = aDecoder.decodeObject(forKey: Key.fullName) as! String
        let short_name = aDecoder.decodeObject(forKey: Key.shortName) as! String
        self.init(full_name: full_name, short_name: short_name)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(full_name, forKey: Key.fullName)
        aCoder.encode(short_name, forKey: Key.shortName)
    }
    struct Key {
        static let fullName = "TCfullName"
        static let shortName = "TCshortName"
    }
}

//{"id":1021252,"brief":"МодС","title":"Моделювання систем","hours":[ {"type":10,"val":18,"teachers":[ 412 ]} , {"type":0,"val":30,"teachers":[ 245 ]} ]}

public class Subject: NSObject, NSCoding {
    public var briefTitle: String
    public var fullTitle: String
    public init(briefTitle: String, fullTitle: String) {
        self.briefTitle = briefTitle
        self.fullTitle = fullTitle
    }
    public convenience override init() {
        self.init(briefTitle: String(), fullTitle: String())
    }
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        let briefTitle = aDecoder.decodeObject(forKey: Key.briefTitle) as! String
        let fullTitle = aDecoder.decodeObject(forKey: Key.fullTitle) as! String
        self.init(briefTitle: briefTitle, fullTitle: fullTitle)
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(briefTitle, forKey: Key.briefTitle)
        aCoder.encode(fullTitle, forKey: Key.fullTitle)
    }
    struct Key {
        static let briefTitle = "SBBriefTitle"
        static let fullTitle = "SBFullTitle"
    }
}

// {"id":0,"short_name":"Лк","full_name":"Лекція", "id_base":0, "type":"lecture"}

public class NureType: NSObject, NSCoding {
    public var id: String
    public var short_name: String
    public var full_name: String
    public init(short_name: String, full_name: String, id: String) {
        self.id = id
        self.short_name = short_name
        self.full_name = full_name
    }
    public convenience override init() {
        self.init(short_name: String(), full_name: String(), id: String())
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        let short_name = aDecoder.decodeObject(forKey: Key.short_name) as! String
        let full_name = aDecoder.decodeObject(forKey: Key.full_name) as! String
        let id = aDecoder.decodeObject(forKey: Key.id_key) as! String
        self.init(short_name: short_name, full_name: full_name, id: id)
    }
    public func encode(with aCoder: NSCoder) {
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

public enum alarmTime: Int {
    case fifteenMinutes = 0
    case oneHour = 1
    case oneDay = 2
    case never = 3
}

public class Note: NSObject, NSCoding {
    public let idToken: String
    public let coupledEventTitle: String
    public let creationDate: String
    public var updateDate: String
    public var text: String
    public var isCoupledEventCustom: Bool
    public var calendarEventId: String
    public var alarmTimePreferneces: Int
    
    public init(idToken: String,
                coupledEventTitle: String,
                creationDate: String,
                updatedDate: String,
                text: String,
                isCoupledEventCustom: Bool,
                calendarEventId: String,
                alarmTimePreferneces: Int) {
        self.idToken = idToken
        self.coupledEventTitle = coupledEventTitle
        self.creationDate = creationDate
        self.updateDate = updatedDate
        self.text = text
        self.isCoupledEventCustom = isCoupledEventCustom
        self.calendarEventId = calendarEventId
        self.alarmTimePreferneces = alarmTimePreferneces
    }
    
    public convenience override init() {
        self.init(idToken: String(),
                  coupledEventTitle: String(),
                  creationDate: String(),
                  updatedDate: String(),
                  text: String(),
                  isCoupledEventCustom: Bool(),
                  calendarEventId: String(),
                  alarmTimePreferneces: Int())
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        let idToken = aDecoder.decodeObject(forKey: Key.idTokenKey) as! String
        let coupledEventTitle = aDecoder.decodeObject(forKey: Key.coupledEventTitleKey) as! String
        let creationDate = aDecoder.decodeObject(forKey: Key.creationDateKey) as! String
        let updatedDate = aDecoder.decodeObject(forKey: Key.updatedDateKey) as! String
        let text = aDecoder.decodeObject(forKey: Key.textKey) as! String
        let isCoupleEventCustom = aDecoder.decodeBool(forKey: Key.isCoupledEventCustomKey)
        let calendarEventId = aDecoder.decodeObject(forKey: Key.calendarEventIdKey) as! String
        let alarmTimePreferneces = aDecoder.decodeInteger(forKey: Key.alarmTimePrefernecesKey)
        self.init(idToken: idToken,
                  coupledEventTitle: coupledEventTitle,
                  creationDate: creationDate,
                  updatedDate: updatedDate,
                  text: text,
                  isCoupledEventCustom: isCoupleEventCustom,
                  calendarEventId: calendarEventId,
                  alarmTimePreferneces: alarmTimePreferneces)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.idToken, forKey: Key.idTokenKey)
        aCoder.encode(self.coupledEventTitle, forKey: Key.coupledEventTitleKey)
        aCoder.encode(self.creationDate, forKey: Key.creationDateKey)
        aCoder.encode(self.updateDate, forKey: Key.updatedDateKey)
        aCoder.encode(self.text, forKey: Key.textKey)
        aCoder.encode(self.isCoupledEventCustom, forKey: Key.isCoupledEventCustomKey)
        aCoder.encode(self.calendarEventId, forKey: Key.calendarEventIdKey)
        aCoder.encode(self.alarmTimePreferneces, forKey: Key.alarmTimePrefernecesKey)
    }
    
    struct Key {
        static let idTokenKey = "NTIDTokenKey"
        static let coupledEventTitleKey = "NTcoupledEventTitle"
        static let creationDateKey = "NTcreationDate"
        static let updatedDateKey = "NTupdatedDate"
        static let textKey = "NTTextKEy"
        static let isCoupledEventCustomKey = "NTIscoupledEventCustomKey"
        static let calendarEventIdKey = "NTCalendarEcentIdKey"
        static let alarmTimePrefernecesKey = "NTalarmTimePrefernecesKey"
    }
}

public class NoteGroup: NSObject, NSCoding {
    public var groupTitle: String
    public var notes: [Note]
    
    public init(groupTitle: String, notes: [Note]) {
        self.groupTitle = groupTitle
        self.notes = notes
    }
    
    public convenience override init() {
        self.init(groupTitle: "", notes: [Note]())
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        let groupTitle = aDecoder.decodeObject(forKey: Key.groupTitleKey) as! String
        let notes = aDecoder.decodeObject(forKey: Key.notesKey) as! [Note]
        self.init(groupTitle: groupTitle, notes: notes)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.groupTitle, forKey: Key.groupTitleKey)
        aCoder.encode(self.notes, forKey: Key.notesKey)
    }
    
    struct Key {
        static let groupTitleKey = "NTGroupTitleKey"
        static let notesKey = "NTNotesKey"
    }
}

/// All user defined ( custom ) data are saved in this class
public class CustomData: NSObject, NSCoding {
    
    // Properties:
    public var groups = [String: String]()
    public var teachers = [String: Teacher]()
    public var subjects = [String: Subject]()
    public var types = [String: NureType]()
    public var events = [Event]()
    
    // initialization:
    public init(groups: [String: String],
                teachers: [String: Teacher],
                subjects: [String: Subject],
                types: [String: NureType],
                events: [Event]) {
        self.groups = groups
        self.teachers = teachers
        self.subjects = subjects
        self.types = types
        self.events = events
    }
    
    public convenience override init() {
        self.init(groups: [:], teachers: [:], subjects: [:], types: [:], events: [])
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
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
    
    public func encode(with aCoder: NSCoder) {
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
public struct EventCache {
    public var events = [Event]()
    public init(events: [Event]) {
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

// ----------------------------------------------------------------------------------------

    // MARK: - Methods: (Data logic)

// ----------------------------------------------------------------------------------------
public extension Shedule {
    
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
    
    func numberOfNotesInSchedule() -> Int {
        
        var numberOfNotes = 0
        
        for noteGroup in self.notes {
            numberOfNotes += noteGroup.notes.count
        }
        return numberOfNotes
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
    
    func deleteCustomEvent(_ event: Event) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        // find the corresponding day:
        let day = self.days[formatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.start_time)))]
        // delete event from corresponding day:
        for i in 0..<day!.events.count {
            if day!.events[i].start_time == event.start_time {
                day!.events.remove(at: i)
                break
            }
        }
        // delete day if there are no more events:
        if day!.events.isEmpty {
            self.days[formatter.string(from: Date(timeIntervalSince1970: TimeInterval(event.start_time)))] = nil
        }
        
        // delete event from customData.events:
        for i in 0..<customData.events.count {
            if customData.events[i].start_time == event.start_time {
                customData.events.remove(at: i)
                return
            }
        }
        
    }
    
    func deleteEventFromCache(_ indexPath: IndexPath, event: Event) {
        for i in 0..<eventsCache["\(indexPath.section)\(indexPath.row)"]!.events.count {
            if eventsCache["\(indexPath.section)\(indexPath.row)"]!.events[i].start_time == event.start_time {
                eventsCache["\(indexPath.section)\(indexPath.row)"]!.events.remove(at: i)
                return
            }
        }
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
    
    func deleteTeacherIfUnused(_ id: String) {
        
        guard Int(id)! < -1 else {
            return
        }
        
        for event in customData.events {
            if event.teachers[0] == Int(id) {
                return
            }
        }
        
        //if there are no more events that use such teacher delete it:
        customData.teachers[id] = nil
        teachers[id] = nil
    }
    
    func deleteTypeIfUnused(_ id: String) {
        guard Int(id)! < -1 else {
            return
        }
        
        for event in customData.events {
            if event.type == id {
                return
            }
        }
        
        //if there are no more events that use such type delete it:
        customData.types[id] = nil
        types[id] = nil
    }
    
    func deleteSubjectIfUnused(_ id: String) {
        guard Int(id)! < -1 else {
            return
        }
        
        for event in customData.events {
            if event.subject_id == id {
                return
            }
        }
        
        //if there are no more events that use such subject, delete it:
        customData.subjects[id] = nil
        subjects[id] = nil
    }
    
    func deleteGroupIfUnused(_ id: String) {
        guard Int(id)! < -1 else {
            return
        }
        
        for event in customData.events {
            if event.groups[0] == Int(id) {
                return
            }
        }
        
        //if there are not more events that use such group, delete it:
        customData.groups[id] = nil
        groups[id] = nil
    }
    
    static func urlForSharedScheduleContainer() -> String {

        let directoryURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppData.sharedContainerIdentifier)
        let fileURL = directoryURL?.appendingPathComponent("SharedSchedule.plist")
        return fileURL!.path
    }
    
    // Data saving methods:
    
     func saveShedule() {
    
        let save = NSKeyedArchiver.archiveRootObject(self, toFile: "\(Shedule.urlPath.path)/\(self.shedule_id)")
        if !save {
            print("Error when saving")
        }
    }
    
    func saveScheduleToSharedContainer() {
        
        let filePath = Shedule.urlForSharedScheduleContainer()
        let save = NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        
        // Set mark for app extension to notify that schedule has been changed:
        let sharedDefaults = UserDefaults(suiteName: AppData.sharedContainerIdentifier)
        sharedDefaults?.set(true, forKey: AppData.isScheduleUpdated)
        sharedDefaults?.synchronize()

        if !save {
            print("Error when saving to shared container!")
        }
    }
}
