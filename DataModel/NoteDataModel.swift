//
//  NoteDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

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
