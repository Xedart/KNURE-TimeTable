//
//  EventDetailViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/18/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import DataModel

class NoteTextView: UITextView {
    
    var shouldResignFirstResponder = true
    
    override func resignFirstResponder() -> Bool {
        if shouldResignFirstResponder {
            super.resignFirstResponder()
            return true
        }
        return false
    }
}

protocol EventDetailViewControllerDelegate {
    var alarmTimePreferences: alarmTime {get set}
    var tableView: UITableView! {get set}
}

class EventDetailViewController: UITableViewController, EventDetailViewControllerDelegate {
    
    // MARK: - Properties:
    
    var closeButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    var delegate: CollectionScheduleViewControllerDelegate!
    var sectionHeader: EventDetailHeaderView!
    var noteTextView: NoteTextView!
    var displayedEvent: Event!
    var currentSchedule: Shedule!
    var indexPath: IndexPath!
    var noteText = String()
    var alarmTimePreferences = alarmTime.fifteenMinutes
    
    // MARK: ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Information
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatSkyBlue()]
        
        // Navigation bar:
        closeButton = UIBarButtonItem(title: AppStrings.Done, style: .done, target: self, action: #selector(EventDetailViewController.closeController(_:)))
        navigationItem.leftBarButtonItem = closeButton
        if displayedEvent.isCustom {
            deleteButton = UIBarButtonItem(title: AppStrings.Delete, style: .plain, target: self, action: #selector(EventDetailViewController.deleteEvent))
            deleteButton.tintColor = UIColor.red
            navigationItem.rightBarButtonItem = deleteButton
        }
        
        //initialize alarmTimePreferences:
        if !displayedEvent.isCustom {
            if let note = currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) {
                alarmTimePreferences = alarmTime(rawValue: note.alarmTimePreferneces)!
            }
        }
        
        // adding observer notification for schedule:
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailViewController.getNewSchedule), name: NSNotification.Name(rawValue: AppData.scheduleDidReload), object: nil)
        // noteTextViewNotifications:
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailViewController.openNoteTextView), name: NSNotification.Name(rawValue: AppData.openNoteTextView), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EventDetailViewController.closeNoteTextView), name: NSNotification.Name(rawValue: AppData.blockNoteTextView), object: nil)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    // MARK: Navigation:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationViewController = segue.destination as! NotificationPreferencesTableViewController
        destionationViewController.delegate = self
    }
    
    // MARK: Sub-methods:
    
    func closeController(_ sender: UIBarButtonItem) {
        if noteTextView != nil {
        noteTextView.shouldResignFirstResponder = true
        _ = noteTextView.resignFirstResponder()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNewSchedule() {
        currentSchedule = delegate.shedule
    }
    
    func saveNoteButtonTaped(_ sender: UIButton) {
        
        noteTextView.shouldResignFirstResponder = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let startDate = Date(timeIntervalSince1970: TimeInterval(displayedEvent.start_time))
        let endDate = Date(timeIntervalSince1970: TimeInterval(displayedEvent.end_time))
        
        let converter = DateFormatter()
        converter.dateStyle = .short
        
        // Add new note:
        if currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) == nil {
            let newNote = Note(idToken: "\(displayedEvent.subject_id)\(displayedEvent.start_time)", coupledEventTitle: currentSchedule.subjects[displayedEvent.subject_id]!.briefTitle, creationDate: converter.string(from: Date(timeIntervalSince1970: TimeInterval(displayedEvent.start_time))), updatedDate: converter.string(from: Date()), text: noteText, isCoupledEventCustom: displayedEvent.isCustom, calendarEventId: String(), alarmTimePreferneces: alarmTimePreferences.rawValue)
            
            // Sync with calendar:
            // We add to the calendar only notes from non-custom events. Custom events notes are going to "Notes" field of custom event's calendar event.
            //
            // Non custom event:
            if !displayedEvent.isCustom {
                if CalendarManager.shouldSycNotes() {
                    appDelegate.eventsManager.addEvent(startTime: startDate, endTime: endDate, title: noteText, eventNoteText: nil, alarmTime: alarmTimePreferences, linkedEvent: displayedEvent)
                    newNote.calendarEventId = displayedEvent.calendarEventId
                }
            }
            
            // Custom event:
            else if displayedEvent.isCustom {
                if CalendarManager.shouldSycNotes() {
                    appDelegate.eventsManager.updateEventNotes(eventId: displayedEvent.calendarEventId, notesText: noteText)
                    newNote.calendarEventId = displayedEvent.calendarEventId
                }
            }
            //save note:
            currentSchedule.addNewNote(newNote)
            
        // Update an existing note:
        } else {
           let updatedNote = currentSchedule.getNoteWithTokenId(displayedEvent.getEventId)
            
            // Delete:
            if noteText.isEmpty {
                
                // Sync with calendar:
                // Non custom event:
                if !displayedEvent.isCustom {
                    if CalendarManager.shouldSycNotes() {
                        appDelegate.eventsManager.deleteEvent(eventId: updatedNote!.calendarEventId)
                    }
                }
                
                // Custom event:
                else if displayedEvent.isCustom {
                    if CalendarManager.shouldSycNotes() {
                        appDelegate.eventsManager.updateEventNotes(eventId: displayedEvent.calendarEventId, notesText: nil)
                    }
                }
                // delete note from schedule:
               _ = currentSchedule.deleteNoteWithId(updatedNote!.idToken)
                
            //Update:
            } else {
                
                // Sync with calendar:
                // Non custom event:
                if !displayedEvent.isCustom {
                    if CalendarManager.shouldSycNotes() {
                        appDelegate.eventsManager.updateEvent(startTime: startDate, endTime: endDate, newTitle: noteText, alarmTime: alarmTimePreferences, linkedEvent: displayedEvent, calendarEventID: updatedNote!.calendarEventId)
                        updatedNote?.calendarEventId = displayedEvent.calendarEventId
                        updatedNote?.alarmTimePreferneces = alarmTimePreferences.rawValue
                    }
                }
                
                // Custom event:
                else if displayedEvent.isCustom {
                    if CalendarManager.shouldSycNotes() {
                        appDelegate.eventsManager.updateEventNotes(eventId: displayedEvent.calendarEventId, notesText: noteText)
                    }
                }
                
                // Update note:
                updatedNote!.text = noteText
                updatedNote!.updateDate = converter.string(from: Date())
                
            }
        }
        
        currentSchedule.saveShedule()
        delegate.passScheduleToLeftController()

        
        _ = noteTextView.resignFirstResponder()
        sectionHeader.hideSaveButton()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.reloadNotification), object: nil)
        // done animation:
        SVProgressHUD.setInfoImage(UIImage(named: "tableBookmark"))
        DispatchQueue.main.async(execute: {
            SVProgressHUD.showInfo(withStatus: AppStrings.Saved)
        })
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            SVProgressHUD.dismiss()
        }
        noteTextView.textColor = UIColor.darkGray
    }
    
    func deleteEvent() {
        
        //Sync with calendar:
        if CalendarManager.shouldSyncEvents() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.eventsManager.deleteEvent(eventId: displayedEvent.calendarEventId)
        }
        
        //delete note:
        _ = currentSchedule.deleteNoteWithId(displayedEvent.getEventId)
        
        //delete event from shedule.days /
        //delete event from custom data:
        currentSchedule.deleteCustomEvent(displayedEvent)
        
        // delete event from eventcache:
        currentSchedule.deleteEventFromCache(indexPath, event: displayedEvent)
        
        // delete teacher/ type/ subject/ group/ from shedule if needed:
        
        //teacher:
        currentSchedule.deleteTeacherIfUnused(String(displayedEvent.teachers[0]))
        
        //type:
        currentSchedule.deleteTypeIfUnused(displayedEvent.type)
        
        //subject:
        currentSchedule.deleteSubjectIfUnused(displayedEvent.subject_id)
        
        //groups:
        currentSchedule.deleteGroupIfUnused(String(displayedEvent.groups[0]))
        
        // save schedule:
        currentSchedule.saveShedule()
        currentSchedule.saveScheduleToSharedContainer()
        
        NotificationCenter.default.post(name: NSNotification.Name(AppData.reloadTableView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(AppData.reloadCollectionView), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

    // MARK: - UITableViewDataSourcr/Delegte:

extension EventDetailViewController {
    
   // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 3 {
            if CalendarManager.shouldSycNotes() && !displayedEvent.isCustom {
                return 2
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        // Sections 0,1,2 display information about event
        case 0...2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell", for: indexPath) as! EventDetailTableViewCell
            
            cell.configureFor(indexPath: indexPath, schedule: currentSchedule, event: displayedEvent)
            return cell
            
        // Section 3 displayes noteTextView and alarm preferences cell:
        case 3:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailInfoTitleCell", for: indexPath) as! EventDetailInfoTitleCell
                
                cell.configure(schedule: currentSchedule, event: displayedEvent)
                cell.eventTitleView.delegate = self
                if !self.noteText.isEmpty {
                    cell.eventTitleView.text = self.noteText
                }
                noteTextView = cell.eventTitleView
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvenatDetailNotificationPreferenceCell", for: indexPath) as! EvenatDetailNotificationPreferenceCell
                cell.configure(preferences: alarmTimePreferences)
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    //UITableViewDelegate:
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                return 100
            } else {
                return 50
            }
        }
        else if (indexPath as NSIndexPath).section == 1 {
            return 60
        } else if (indexPath as NSIndexPath).section == 2 {
            return 60
        } else if (indexPath as NSIndexPath).section == 3 {
            if indexPath.row == 0 {
                return 100
            } else {
                return 60
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let headerView = EventDetailHeaderView(frame: tableView.rectForHeader(inSection: section))
        headerView.saveNoteButton.addTarget(EventDetailViewController(), action: #selector(EventDetailViewController.saveNoteButtonTaped(_:)), for: .touchUpInside)
        headerView.configure(section)
        if section == 3 {
            self.sectionHeader = headerView
            if !noteText.isEmpty {
                self.sectionHeader.showSaveButton()
            }
        }
        return headerView
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
}


    // MARK: - UITextView Delegate



extension EventDetailViewController: UITextViewDelegate {
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        sectionHeader.showSaveButton()
        noteText = textView.text
    }
    
    func openNoteTextView() {
        noteTextView?.shouldResignFirstResponder = true
    }
    
    func closeNoteTextView() {
        noteTextView?.shouldResignFirstResponder = false
    }
}
