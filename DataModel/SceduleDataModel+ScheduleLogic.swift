//
//  SceduleDataModel+ScheduleLogic.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

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
                if day!.events[i].isCustom {
                    day!.events.remove(at: i)
                    break
                }
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
        //since there can be only one custom event per one IndexPath in collection view,
        //just find it among others events in eventcache, and remove:
        for i in 0..<eventsCache["\(indexPath.section)\(indexPath.row)"]!.events.count {
            if eventsCache["\(indexPath.section)\(indexPath.row)"]!.events[i].isCustom {
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
