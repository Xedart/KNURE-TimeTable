//
//  Parser.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SwiftyJSON

class Parser {
    
    static func parseAuditoriesList(data: JSON, callback: (data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        let buildings = data["university"]["buildings"].arrayValue
        
         for building in buildings {
            var resultRow = ListSection()
            resultRow.title = building["full_name"].stringValue
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
        callback(data: resultList)
    }
    
    static func parseTeachersList(data: JSON, callback: (data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        let faculties = data["university"]["faculties"].arrayValue
        
        for faculty in faculties {
            var resultRow = ListSection()
            resultRow.title = " Факультет \(faculty["short_name"].stringValue)" // Value
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
        callback(data: resultList)
    }
    
    static func parseGroupsLst(data: JSON, callback: (data: [ListSection]) -> Void) {
        var resultList = [ListSection]()
        
        let faculties = data["university"]["faculties"].arrayValue
        for faculty in faculties {
            
            var resultRow = ListSection()
            resultRow.title = " Факультет \(faculty["full_name"].stringValue)" // Value
            
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
        callback(data: resultList)
    }
    
    
    static func parseSchedule(data: JSON, callback: (data: Shedule) -> Void) {
        
        // perform data arrays for filling:
        var result_types = [String: NureType]()
        var result_teachers = [String: Teacher]()
        var result_subjects = [String: Subject]()
        var result_groups = [String: String]()
        var result_days = [String: Day]()
        var firstDayTime = Int()
        var lastDayTime = Int()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
       
        let jsTypes = data["types"].arrayValue
        
        // grab types:
        for type in jsTypes {
            let id = type["id"].stringValue
            let short_name = type["short_name"].stringValue
            let full_name = type["full_name"].stringValue
            let type_id = type["id"].stringValue
            let nure_type = NureType(short_name: short_name, full_name: full_name, id: id)
            result_types[type_id] = nure_type
        }
        
        // grab teachers:
        let jsTeachers = data["teachers"].arrayValue
        for teacher in jsTeachers {
            let short_name = teacher["short_name"].stringValue
            let full_name = teacher["full_name"].stringValue
            let teacher_id = teacher["id"].stringValue
            let nure_teacher = Teacher(full_name: full_name, short_name: short_name)
            result_teachers[teacher_id] = nure_teacher
        }
        
        // grab subjects:
        let jsSubjects = data["subjects"].arrayValue
        for subject in jsSubjects {
            let briefTitle = subject["brief"].stringValue
            let title = subject["title"].stringValue
            let subject_id = subject["id"].stringValue
            let nure_subject = Subject(briefTitle: briefTitle, fullTitle: title)
            result_subjects[subject_id] = nure_subject
        }
        
        // grab groups:
        let jsGroups = data["groups"].arrayValue
        for jgroup in jsGroups {
            let groupId = jgroup["id"].stringValue
            let name = jgroup["name"].stringValue
            result_groups[groupId] = name
        }
        
        // grab events:
        let jsEvents = data["events"].arrayValue
        if let startTime = jsEvents.first?["start_time"].intValue {
            firstDayTime = startTime
        }
        if let lastTime = jsEvents.last?["start_time"].intValue {
            lastDayTime = lastTime
        }
        var daysBuffer = Day()
        var currentDateStr = formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(firstDayTime)))
        
        for event in jsEvents {
            let id = event["subject_id"].stringValue
            let start_time = event["start_time"].intValue
            let end_time = event["end_time"].intValue
            let type = event["type"].stringValue
            let numberPair = event["number_pair"].intValue
            let auditory = event["auditory"].stringValue
            var teachers = [Int]()
            var groups = [Int]()
            for teacher in event["teachers"].arrayValue {
                teachers.append(teacher.intValue)
            }
            for jgroup in event["groups"].arrayValue {
                groups.append(jgroup.intValue)
            }
            let event = Event(subject_id: id, start_time: start_time, end_time: end_time, type: type, numberOfPair: numberPair, auditory: auditory, teachers: teachers, groups: groups)
            let eventDateStringId = formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(start_time)))
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
        let result = Shedule(startDayTime: firstDayTime, endDayTime: lastDayTime, shedule_id: "", days: result_days, groups: result_groups, teachers: result_teachers, subjects: result_subjects, types: result_types, scheduleIdentifier: "", notes: [NoteGroup]())
        callback(data: result)
    }
}