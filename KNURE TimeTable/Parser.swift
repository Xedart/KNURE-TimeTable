//
//  Parser.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

class Parser {
    
    static func parseAuditoriesList(_ data: JSON, callback: (_ data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        let buildings = data["university"]["buildings"].arrayValue
        
         for building in buildings {
            var resultRow = ListSection()
            resultRow.title = " \(building["full_name"].stringValue)"
            let auditories = building["auditories"].arrayValue
            for auditory in auditories {
                let aud_id = auditory["id"].stringValue
                let aud_title = auditory["short_name"].stringValue
                let row = ListRow(row_id: aud_id, row_title: aud_title)
                if !resultRow.containsRow(aud_id) {
                    resultRow.rows.append(row)
                }
            }
            resultList.append(resultRow)
        }
        callback(resultList)
    }
    
    static func parseTeachersList(_ data: JSON, callback: (_ data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        let faculties = data["university"]["faculties"].arrayValue
        
        for faculty in faculties {
            var resultRow = ListSection()
            resultRow.title = " \(AppStrings.Faculty) \(faculty["short_name"].stringValue)" // Value
            let departments = faculty["departments"].arrayValue
            for department in departments {
                let teachers = department["teachers"].arrayValue
                
                for teacher in teachers {
                    let teacher_id = teacher["id"].stringValue
                    let short_name = teacher["short_name"].stringValue
                    let row = ListRow(row_id: teacher_id, row_title: short_name)
                    if !resultRow.containsRow(teacher_id) {
                        resultRow.rows.append(row)
                    }
                }
            }
            resultList.append(resultRow)
        }
        callback(resultList)
    }
    
    static func parseGroupsLst(_ data: JSON, callback: (_ data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        
        let faculties = data["university"]["faculties"].arrayValue
        for faculty in faculties {
            
            var resultRow = ListSection()
            resultRow.title = " \(AppStrings.Faculty) \(faculty["full_name"].stringValue)" // Value
            
            let directions = faculty["directions"].arrayValue
            for direction in directions {
                let groups = direction["groups"].arrayValue
                for group in groups {
                    let group_id = group["id"].stringValue
                    let group_title = group["name"].stringValue
                    let row = ListRow(row_id: group_id, row_title:  group_title)
                    if !resultRow.containsRow(group_id) {
                        resultRow.rows.append(row)
                    }
                }
                let specializes = direction["specialities"].arrayValue
                for splecialiti in specializes {
                    let groups = splecialiti["groups"].arrayValue
                    for group in groups {
                        let group_id = group["id"].stringValue
                        let group_title = group["name"].stringValue
                        let row = ListRow(row_id: group_id, row_title:  group_title)
                        if !resultRow.containsRow(group_id) {
                            resultRow.rows.append(row)
                        }
                    }
                }
            }
            resultList.append(resultRow)
        }
        callback(resultList)
    }
    
    
    static func parseSchedule(_ data: JSON, callback: (_ data: Shedule) -> Void) {
        
        // perform dictionaries:
        var result_types = [String: NureType]()
        var result_teachers = [String: Teacher]()
        var result_subjects = [String: Subject]()
        var result_groups = [String: String]()
        var result_days = [String: Day]()
        
        var firstDayTime = Int()
        var lastDayTime = Int()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        // grab types:
        let jsTypes = data["types"].arrayValue
        for type in jsTypes {
            let id = type["id"].stringValue
            let nure_type = NureType(jsonData: type)
            result_types[id] = nure_type
        }
        
        // grab teachers:
        let jsTeachers = data["teachers"].arrayValue
        for jsTeacher in jsTeachers {
            let teacher_id = jsTeacher["id"].stringValue
            let nure_teacher = Teacher(jsonData: jsTeacher)
            result_teachers[teacher_id] = nure_teacher
        }
        
        // grab subjects:
        let jsSubjects = data["subjects"].arrayValue
        for jsSubject in jsSubjects {
            let subject_id = jsSubject["id"].stringValue
            let nure_subject = Subject(jsonData: jsSubject)
            result_subjects[subject_id] = nure_subject
        }
        
        // grab groups:
        let jsGroups = data["groups"].arrayValue
        for jsGroup in jsGroups {
            let groupId = jsGroup["id"].stringValue
            let name = jsGroup["name"].stringValue
            result_groups[groupId] = name
        }
        
        // grab events:
        let jsEvents = data["events"].arrayValue
        if let startTime = jsEvents.first?["start_time"].intValue {
            //calculate first day start time:
            let secondsFromBeginToPair = AppData.secondsFromDayBeginToPair(numberOfPair: jsEvents.first?["number_pair"].intValue)
            firstDayTime = startTime - secondsFromBeginToPair
            
        }
        if let lastTime = jsEvents.last?["start_time"].intValue {
            lastDayTime = lastTime
        }
        var daysBuffer = Day()
        var currentDateStr = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(firstDayTime)))
        
        for jsEvent in jsEvents {
            
            let start_time = jsEvent["start_time"].intValue
            
            let event = Event(jsonData: jsEvent)
            let eventDateStringId = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(start_time)))
            if currentDateStr == eventDateStringId {
                daysBuffer.events.append(event)
            } else {
                result_days[currentDateStr] = daysBuffer
                currentDateStr = eventDateStringId
                daysBuffer = Day()
                daysBuffer.events.append(event)
            }
            defer {
                result_days[currentDateStr] = daysBuffer // need to do it for last day of the semester
            }
        }
        
        let refreshDate = formatter.string(from: Date())
        
        let result = Shedule(startDayTime: firstDayTime, endDayTime: lastDayTime, shedule_id: "", days: result_days, groups: result_groups, teachers: result_teachers, subjects: result_subjects, types: result_types, scheduleIdentifier: "", notes: [NoteGroup](), lastRefreshDate: refreshDate, customData: CustomData())
        callback(result)
    }
}
