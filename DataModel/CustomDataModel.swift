//
//  CustomDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

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
