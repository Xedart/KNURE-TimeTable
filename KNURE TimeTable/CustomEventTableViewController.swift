//
//  CustomEventTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 7/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel


protocol CustomEventTableViewControllerDelegate {
    var customEvent: Event! {get}
    var shedule: Shedule {get}
    var isTeacherAdded: Bool {get set}
    var isTypeAdded: Bool {get set}
    var isAuditoryAdded: Bool {get set}
    var isSubjectAdded: Bool {get set}
    var isGroupAdded: Bool {get set}
}

class CustomEventTableViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var DisplayedChoiseLabel: UILabel!
}

class CusomEventTableVIewControllerNoteCell: UITableViewCell {
    
    @IBOutlet weak var noteTextView: NoteTextView!
    
}

class CustomEventTableViewController: UITableViewController, CustomEventTableViewControllerDelegate, EventDetailViewControllerDelegate {
    
    // MARK: Properties:
    
    var delegate: CollectionScheduleViewControllerDelegate!
    var indexPath: IndexPath!
    var customEvent: Event!
    var shedule: Shedule {
        return delegate.shedule
    }
    
    var closeButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var noteTextView: NoteTextView!
    var alarmTimePreferences = alarmTime.fifteenMinutes

    var isTeacherAdded = false
    var isTypeAdded = false
    var isAuditoryAdded = false
    var isSubjectAdded = false
    var isGroupAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation item setup:
        navigationItem.title = AppStrings.addEvent
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatSkyBlue()]
        
        // cancel button:
        closeButton = UIBarButtonItem(title: AppStrings.cancel, style: .done, target: self, action: #selector(CustomEventTableViewController.close))
        navigationItem.leftBarButtonItem = closeButton
        
        //save button:
        saveButton = UIBarButtonItem(title: AppStrings.Save, style: .plain, target: self, action: #selector(CustomEventTableViewController.save))
        navigationItem.rightBarButtonItem = saveButton
        
        // noteTextViewNotifications:
        NotificationCenter.default.addObserver(self, selector: #selector(CustomEventTableViewController.openNoteTextView), name: NSNotification.Name(rawValue: AppData.openNoteTextView), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomEventTableViewController.closeNoteTextView), name: NSNotification.Name(rawValue: AppData.blockNoteTextView), object: nil)
        
        //configuring schedule for new values:
        delegate.shedule.types[String(-1)] = NureType(short_name: AppStrings.customTypeShort, full_name: AppStrings.customType, id: String(-1))
        delegate.shedule.teachers[String(-1)] = Teacher(full_name: "-", short_name: "-")
        delegate.shedule.groups[String(-1)] = "-"
        delegate.shedule.subjects.updateValue(Subject(briefTitle: AppStrings.customEvent, fullTitle: AppStrings.customEvent), forKey: String(-1))
        
        //configuring custom data for new values:
        delegate.shedule.customData.types[String(-1)] = NureType(short_name: AppStrings.customTypeShort, full_name: AppStrings.customType, id: String(-1))
        delegate.shedule.customData.teachers[String(-1)] = Teacher(full_name: "-", short_name: "-")
        delegate.shedule.customData.groups[String(-1)] = "-"
        delegate.shedule.customData.subjects.updateValue(Subject(briefTitle: AppStrings.customEvent, fullTitle: AppStrings.customEvent), forKey: String(-1))
        
        //default customEvent setup:
        
        let pairStartTime = delegate.shedule.startDayTime + (indexPath.section * AppData.unixDay) + AppData.secondsFromDayBeginToPair(numberOfPair: indexPath.row + 1)
        let pairEndTime = pairStartTime + AppData.pairTime
        
        customEvent = Event(subject_id: "-1", start_time: pairStartTime, end_time: pairEndTime, type: "-1", numberOfPair: indexPath.row + 1, auditory: "-", teachers: [-1], groups: [-1], isCustom: true, alarmTime: alarmTime.fifteenMinutes.rawValue, calendarEventId: String())
    }
    
    // MARK: - Methods:
    
    func close() {
        
        //Clean the data if dusmiss:
        
        if isTeacherAdded {
            let id = shedule.customData.teachers.count
            shedule.teachers[String(-id)] = nil
            shedule.customData.teachers[String(-id)] = nil
        }
        if isTypeAdded {
            let id = shedule.customData.types.count
            shedule.types[String(-id)] = nil
            shedule.customData.types[String(-id)] = nil
        }
        if isSubjectAdded {
            let id = shedule.customData.subjects.count
            shedule.subjects[String(-id)] = nil
            shedule.customData.subjects[String(-id)] = nil
        }
        if isGroupAdded {
            let id = shedule.customData.groups.count
            shedule.groups[String(-id)] = nil
            shedule.customData.groups[String(-id)] = nil
        }
        delegate.collectionView!?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        //hide thekeyboard:
        _ = noteTextView.resignFirstResponder()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        delegate.shedule.insertEvent(customEvent, in: Date(timeIntervalSince1970: TimeInterval(customEvent!.start_time)))
        delegate.shedule.customData.events.append(customEvent)
        
        //add changes to events cache:
        if delegate.shedule.eventsCache["\(indexPath.section)\(indexPath.row)"] != nil {
            delegate.shedule.eventsCache["\(indexPath.section)\(indexPath.row)"]!.events.append(customEvent)
        } else {
            delegate.shedule.eventsCache["\(indexPath.section)\(indexPath.row)"] = EventCache(events: [customEvent])
        }
        
        var newNote: Note?
        
        // save note:
        if noteTextView!.text != AppStrings.AddNote && noteTextView!.text != "" {
            newNote = Note(idToken: customEvent.getEventId, coupledEventTitle: delegate.shedule.subjects[customEvent.subject_id]!.briefTitle, creationDate: formatter.string(from: Date(timeIntervalSince1970: TimeInterval(customEvent.start_time))), updatedDate: formatter.string(from: Date()), text: noteTextView.text!, isCoupledEventCustom: true, calendarEventId: String(), alarmTimePreferneces: alarmTimePreferences.rawValue)
        }
        
        // Sync with calendar:
        if CalendarManager.shouldSyncEvents() {
            let noteText = noteTextView!.text != AppStrings.AddNote && noteTextView!.text != "" ? noteTextView!.text : nil
            syncWithCalendar(noteText: noteText)
            newNote?.calendarEventId = customEvent.calendarEventId
        }
       
        
        //save note:
        if newNote != nil {
            delegate.shedule.addNewNote(newNote!)
        }
        
        delegate.shedule.saveShedule()
        delegate.shedule.saveScheduleToSharedContainer()
        delegate.passScheduleToLeftController()
        
        //reload view:
        delegate.collectionView!?.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(AppData.reloadTableView), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    func syncWithCalendar(noteText: String?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let startTime = Date(timeIntervalSince1970: TimeInterval(customEvent.start_time))
        let endTime = Date(timeIntervalSince1970: TimeInterval(customEvent.end_time))
        let title = shedule.subjects[customEvent.subject_id]?.fullTitle
        
        appDelegate.eventsManager.addEvent(startTime: startTime,
                                           endTime: endTime,
                                           title: title!,
                                           eventNoteText: noteText,
                                           alarmTime: alarmTimePreferences,
                                           linkedEvent: customEvent)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Custom event info configuring cells:
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0...4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventTableViewController", for: indexPath) as! CustomEventTableViewControllerCell
                if UIDevice.current.userInterfaceIdiom == .pad {
                    cell.titleLabel.font = UIFont.systemFont(ofSize: 18.0)
                    let widthConstraint = NSLayoutConstraint(item: cell.titleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 180)
                    view.addConstraint(widthConstraint)
                }
                
                if indexPath.row == 0 {
                    cell.titleLabel.text = AppStrings.Teacher
                    cell.DisplayedChoiseLabel.text = delegate.shedule.teachers[String(customEvent.teachers[0])]!.short_name
                    return cell
                } else if indexPath.row == 1 {
                    cell.titleLabel.text = AppStrings.type
                    cell.DisplayedChoiseLabel.text = delegate.shedule.types[customEvent.type]!.full_name
                    return cell
                } else if indexPath.row == 2 {
                    cell.titleLabel.text = AppStrings.Audytori
                    cell.DisplayedChoiseLabel.text = customEvent.auditory
                    return cell
                } else if indexPath.row == 3 {
                    cell.titleLabel.text = AppStrings.subject
                    cell.DisplayedChoiseLabel.text = delegate.shedule.subjects[customEvent.subject_id]?.fullTitle
                    return cell
                } else if indexPath.row == 4 {
                    cell.titleLabel.text = AppStrings.group
                    cell.DisplayedChoiseLabel.text = delegate.shedule.groups[String(customEvent.groups.first!)]
                    return cell
                }
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationPreferenceCellCustomEvent", for: indexPath) as! EvenatDetailNotificationPreferenceCell
                cell.configure(preferences: alarmTimePreferences)
                return cell
            default:
                print("Unexpected behavior")
            }
            
            // Note cell:
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventTableViewControllerNoteCell", for: indexPath) as! CusomEventTableVIewControllerNoteCell
            cell.noteTextView.text = AppStrings.AddNote
            cell.noteTextView.textColor = UIColor.darkGray
            cell.noteTextView.delegate = self
            noteTextView = cell.noteTextView
            return cell
            
        }
        return UITableViewCell()
    }
    
    //MARK: - TableViewDelegate:
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let sectionHeader = EventDetailHeaderView(frame: tableView.rectForHeader(inSection: section))
        sectionHeader.configure(3) // 3 - notes code
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.0
        } else {
            return 100.0
        }
    }
 
    // MARK: - Navigation:
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as? CustomEventTableViewControllerCell != nil {
            let destionation = segue.destination as! CustomEventConfiguratorTableView
            destionation.delegate = self
            destionation.field = CustomField(rawValue: tableView.indexPathForSelectedRow!.row)
        } else {
            let destionation = segue.destination as! NotificationPreferencesTableViewController
            destionation.delegate = self
        }
    }
}

   //MARK: - TExtViewDelegate:

extension CustomEventTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolderTeext = AppStrings.AddNote
        if textView.text == placeHolderTeext {
            textView.text = ""
        }
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        noteTextView.shouldResignFirstResponder = true
        textView.resignFirstResponder()
        if textView.text.isEmpty {
            textView.text = AppStrings.AddNote
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func openNoteTextView() {
        noteTextView?.shouldResignFirstResponder = true
    }
    
    func closeNoteTextView() {
        noteTextView?.shouldResignFirstResponder = false
    }
}










