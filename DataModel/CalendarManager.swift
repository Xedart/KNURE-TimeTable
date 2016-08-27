//
//  CalendarManager.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 8/21/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import EventKit

public class CalendarManager {
    
    var eventStore: EKEventStore!
    var appCalendar: EKCalendar!
    private var appCalendarIdKey = "AppCalendarIdKey"
    
    public init() {
        
        eventStore = EKEventStore()
        
    }
    
    func requestUserPermission(callback: @escaping () -> Void) {
        
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case EKAuthorizationStatus.notDetermined:
            eventStore.requestAccess(to: .event, completion: { (responce, error) in
                if error == nil {
                    if responce == true {
                        self.loadCalendar()
                        callback()
                    }
                }
            })
        case EKAuthorizationStatus.authorized:
            loadCalendar()
            callback()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            return
        }
    }
    
    func loadCalendar() {
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: appCalendarIdKey) != nil {
            if eventStore.calendar(withIdentifier: defaults.string(forKey: appCalendarIdKey)!) != nil {
                
                // Load calendar from user calendars database:
                appCalendar = eventStore.calendar(withIdentifier: defaults.string(forKey: appCalendarIdKey)!)
                return
            }
        }
        
        // Create calendar:
        appCalendar = EKCalendar(for: .event, eventStore: eventStore)
        appCalendar.title = "NureTimeTable"
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select iCloud source uf it is available
        // or set Local source otherwise:
        
        if let icloudSource = (sourcesInEventStore.filter {
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.calDAV.rawValue
        }.first) {
            appCalendar.source = icloudSource
        } else {
            appCalendar.source = sourcesInEventStore.filter {
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
                }.first!
        }
        
        
        appCalendar.cgColor = UIColor.red.cgColor
        //save calendar:
        do {
            try eventStore.saveCalendar(appCalendar, commit: true)
            defaults.set(appCalendar.calendarIdentifier, forKey: appCalendarIdKey)
        } catch {
            print("Unexpected behavior")
        }
    }
    
    public func deleteEvent(eventId: String) {
        
        requestUserPermission {
            
            if let addedEvent = self.eventStore.event(withIdentifier: eventId) {
                
                // remove event:
                do {
                    try self.eventStore.remove(addedEvent, span: EKSpan.thisEvent)
                } catch {
                    print("Unexpected behavior")
                }
            }
        }
    }
    
    public func updateEventNotes(eventId: String, notesText: String?) {
        
        requestUserPermission {
            
            if let calendarEvent = self.eventStore.event(withIdentifier: eventId) {
                calendarEvent.notes = notesText
                
                // save updateEvent:
                do {
                    try self.eventStore.save(calendarEvent, span: .thisEvent)
                } catch {
                    print()
                }
            }
        }
    }
    
    public func updateEvent(startTime: Date, endTime: Date, newTitle: String, alarmTime: alarmTime, linkedEvent: Event) {
        
        requestUserPermission {
            
            let eventId = linkedEvent.calendarEventId
            
            if let addedEvent = self.eventStore.event(withIdentifier: eventId) {
                
                addedEvent.title = newTitle
                addedEvent.alarms = []
                
                //update an alarm:
                if alarmTime != .never {
                    addedEvent.addAlarm(EKAlarm(absoluteDate: self.getAlarmDate(alarmTime: alarmTime, eventTime: startTime)))
                }
                
                //save updated event:
                do {
                    try self.eventStore.save(addedEvent, span: .thisEvent, commit: true)
                    
                    linkedEvent.alarmPreference = alarmTime.rawValue
                } catch {
                    print("Unexpected behavior")
                }
                return
            }
            
            //If there is no linked event, create one:
            linkedEvent.calendarEventId = ""
            self.addEvent(startTime: startTime, endTime: endTime, title: newTitle, eventNoteText: nil, alarmTime: alarmTime, linkedEvent: linkedEvent)
        }
    }
    
    public func addEvent(startTime: Date, endTime: Date, title: String, eventNoteText: String?, alarmTime: alarmTime, linkedEvent: Event) {
        
        // Try to find and update existing event:
        if linkedEvent.calendarEventId != "" {
            updateEvent(startTime: startTime, endTime: endTime, newTitle: title, alarmTime: alarmTime, linkedEvent: linkedEvent)
        }
        
        requestUserPermission {
            
            //Create calendar event:
            let event = EKEvent(eventStore: self.eventStore!)
            event.title = title
            event.startDate = startTime
            event.endDate = endTime
            event.calendar = self.appCalendar
            event.notes = eventNoteText
            
            if alarmTime != .never {
                // Add an alarm:
                event.addAlarm(EKAlarm(absoluteDate: self.getAlarmDate(alarmTime: alarmTime, eventTime: startTime)))
            }
            
            // ckeck for redundant event
            let predicate = self.eventStore.predicateForEvents(withStart: startTime, end: endTime, calendars: [self.appCalendar])
            let addedEvents = self.eventStore.events(matching: predicate)
            for addedEvent in addedEvents {
                if addedEvent.title == event.title {
                    return
                }
            }
            
            
            // save event:
            do {
                try self.eventStore.save(event, span: .thisEvent, commit: true)
                
                //save event's identifier:
                linkedEvent.calendarEventId = event.eventIdentifier
                linkedEvent.alarmPreference = alarmTime.rawValue
            } catch {
                print("Unexpected behavior")
            }
        }
    }
    
    // MARK: - sub-methods for working with calendar:
    
    func getAlarmDate(alarmTime: alarmTime, eventTime: Date) -> Date {
        
        var alarmDate: Date!
        if alarmTime == .fifteenMinutes {
            
            // 15 minutes is 900 seconds
            alarmDate = Date(timeIntervalSince1970: eventTime.timeIntervalSince1970 - 900)
        } else if alarmTime == .oneHour {
            
            // 1 hour is 3600 seconds
            alarmDate = Date(timeIntervalSince1970: eventTime.timeIntervalSince1970 - 3600)
        } else if alarmTime == .oneDay {
            
            // 1 day is 86 400 seconds
            alarmDate = Date(timeIntervalSince1970: eventTime.timeIntervalSince1970 - 86400)
        }
        return alarmDate
    }
    
    public static func shouldSyncEvents() -> Bool {
        
        let defaults = UserDefaults.standard
        
        if let shouldSync = defaults.object(forKey: AppData.shouldSyncEventsKey) as? Bool {
            return shouldSync
            // default value:
        } else {
            return true
        }
    }
    
    public static func shouldSycNotes() -> Bool {
        
        let defaults = UserDefaults.standard
        
        if let shouldSync = defaults.object(forKey: AppData.shouldSuncNotesKey) as? Bool {
            return shouldSync
            // default value:
        } else {
            return true
        }
    }
}
