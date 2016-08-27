//
//  EventDetailInfoControllerCells.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/19/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel


/// Cell for Notification time preferences where user can choose proper alarm time from list
class NotificationPreferencesCell: UITableViewCell {
    
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    
}

/// Class for EventDetailViewController where displayed current preferred alarm time
class EvenatDetailNotificationPreferenceCell: UITableViewCell {
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var notificationTimePreferences: UILabel!
    
    func configure(preferences: alarmTime) {
        
        notificationLabel.text = AppStrings.recall
        
        if preferences == .fifteenMinutes {
            notificationTimePreferences.text = "\(AppStrings.before) 15 \(AppStrings.minutes)"
        } else if preferences == .oneHour {
            notificationTimePreferences.text = "\(AppStrings.before) 1 \(AppStrings.hour)"
        } else if preferences == .oneDay {
            notificationTimePreferences.text = "\(AppStrings.before) 1 \(AppStrings.day)"
        } else {
            notificationTimePreferences.text = AppStrings.dontRecall
        }
    }
}

/// Cell for EventTableViewController. Used by user to type note's text.
class EventDetailInfoTitleCell: UITableViewCell {

    @IBOutlet weak var eventTitleView: NoteTextView!
    
    func configure(schedule: Shedule, event: Event) {
        
        //set style:
        eventTitleView.isEditable = true
        eventTitleView.font = UIFont.systemFont(ofSize: 18)
        eventTitleView.textColor = UIColor.darkGray
        selectionStyle = .none
        
        // set content:
        if schedule.getNoteWithTokenId(event.getEventId) == nil {
            eventTitleView.text = AppStrings.AddNote
            eventTitleView.textColor = UIColor.lightGray
        } else {
            eventTitleView.text = schedule.getNoteWithTokenId(event.getEventId)!.text
        }
    }
    
}

/// Cells of this class are user by EventDetailViewController to display information about event.
class EventDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextView: UITextView!
    
    func configureFor(indexPath: IndexPath, schedule: Shedule, event: Event) {
        
        selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row == 0 {
                configureForSubject(schedule: schedule, event: event)
            }
            else if indexPath.row == 1 {
                configureForType(schedule: schedule, event: event)
            }
            else if indexPath.row == 2 {
                configureForAuditory(schedule: schedule, event: event)
            }
            
        case 1:
            
            configureForTeacher(schedule: schedule, event: event)
            
        case 2:
            
            configureForGroups(schedule: schedule, event: event)
            
        default:
            print("Unexpected behavior")
        }
        
    }
    
    func configureForSubject(schedule: Shedule, event: Event) {
        
        // set style:
        titleTextView.font = UIFont.systemFont(ofSize: 22)
        titleTextView.textAlignment = .center
        if titleTextView.contentSize.height > titleTextView.frame.height {
            titleTextView.isScrollEnabled = true
        } else {
            titleTextView.isScrollEnabled = false
        }
        
        //set content:
        titleTextView.text = schedule.subjects[event.subject_id]?.fullTitle
    }
    
    func configureForType(schedule: Shedule, event: Event) {
        
        // set style:
        titleTextView.textAlignment = .center
        titleTextView.font = UIFont.systemFont(ofSize: 18)
        titleTextView.isScrollEnabled = false
        
        //set content:
        titleTextView.text = schedule.types[event.type]?.full_name
    }
    
    func configureForAuditory(schedule: Shedule, event: Event) {
        
        // set style:
        titleTextView.font = UIFont.systemFont(ofSize: 18)
        titleTextView.textAlignment = .center
        titleTextView.isScrollEnabled = false
        
        // set content:
        titleTextView.text = "\(AppStrings.Audytori) \(event.auditory)"
    }
    
    func configureForTeacher(schedule: Shedule, event: Event) {
        
        // set content:
        if !event.teachers.isEmpty {
            titleTextView.text = schedule.teachers[String(event.teachers[0])]?.full_name
        }
        
        // set style:
        titleTextView.font = UIFont.systemFont(ofSize: 18)
        titleTextView.textAlignment = .center
    }
    
    func configureForGroups(schedule: Shedule, event: Event) {
        
        // set content:
        var groupsText = String()
        
        for groupId in event.groups {
            groupsText.append(schedule.groups[String(groupId)]!)
            groupsText.append(", ")
        }
        for _ in 0...1 {
            groupsText.remove(at: groupsText.index(before: groupsText.endIndex))
        }
        
        // set style:
        titleTextView.text = groupsText
        titleTextView.font = UIFont.systemFont(ofSize: 18)
        titleTextView.textAlignment = .center
        titleTextView.isScrollEnabled = true
    }
    
}

class EventDetailHeaderView: UIView {
    
    var title = UILabel()
    var saveNoteButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 245/255, alpha: 1)
        
        // title
        title = UILabel(frame: CGRect(x: 8, y: 0, width: self.bounds.width, height: self.bounds.height))
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = FlatSkyBlue()
        self.addSubview(title)
        
        // save button:
        saveNoteButton = UIButton(frame: CGRect(x: self.frame.width - 100, y: self.bounds.origin.y, width: 100, height: self.bounds.height))
        saveNoteButton.setTitle(AppStrings.Save, for: UIControlState())
        saveNoteButton.setTitleColor(AppData.appleButtonDefault, for: UIControlState())
        saveNoteButton.setTitleColor(AppData.appleButtonDefault.withAlphaComponent(0.6), for: .highlighted)
    }
    
    func configure(_ section: Int) {
        switch section {
        case 0:
            title.text = ""
        case 1:
            title.text = AppStrings.Teacher
        case 2:
            title.text = AppStrings.Groups
        case 3:
            title.text = AppStrings.Notes
        case 4:
            title.text = AppStrings.Add
        default:
            title.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showSaveButton() {
        self.addSubview(saveNoteButton)
        self.bringSubview(toFront: saveNoteButton)
    }
    
    func hideSaveButton() {
        saveNoteButton.removeFromSuperview()
    }
}




