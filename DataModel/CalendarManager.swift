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
    var permissionGranted = false
    var appCalendar: EKCalendar!
    private var appCalendarIdKey = "AppCalendarIdKey"
    
    public init() {
        
        eventStore = EKEventStore()
        
    }
    
    func requestUserPermission() {
        
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case EKAuthorizationStatus.notDetermined:
            eventStore.requestAccess(to: .event, completion: { (responce, error) in
                if error == nil {
                    self.permissionGranted = responce
                }
            })
        case EKAuthorizationStatus.authorized:
            loadCalendar()
            permissionGranted = true
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            permissionGranted = false
        }
    }
    
    func loadCalendar() {
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: appCalendarIdKey) != nil {
            if eventStore.calendar(withIdentifier: defaults.string(forKey: appCalendarIdKey)!) != nil {
                
                // load calendar from user calendars database:
                appCalendar = eventStore.calendar(withIdentifier: defaults.string(forKey: appCalendarIdKey)!)
                return
            }
        }
        
        // Create calendar:
        appCalendar = EKCalendar(for: .event, eventStore: eventStore)
        appCalendar.title = "NureTimeTable"
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        appCalendar.source = sourcesInEventStore.filter {
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        appCalendar.cgColor = UIColor.red.cgColor
        //save calendar:
        do {
            try eventStore.saveCalendar(appCalendar, commit: true)
            defaults.set(appCalendar.calendarIdentifier, forKey: appCalendarIdKey)
        } catch {
            print("Unexpected behavior")
        }
    }
    
    
    
    public func addEvent(startTime: Date, endTime: Date, title: String) {
        
        requestUserPermission()
        
        guard permissionGranted else {
            return
        }
        
        
        //Create calendar event:
        let event = EKEvent(eventStore: eventStore!)
        event.title = title
        event.startDate = startTime
        event.endDate = endTime
        event.calendar = appCalendar
        
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
        } catch {
            print("Unexpected behavior")
        }
    }
    
}


