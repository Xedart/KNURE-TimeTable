//
//  EventDetailViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/18/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
//import ChameleonFramework

class NoteTextView: UITextView {
    
    var shouldResignFirstResponder = true
    
    override func canResignFirstResponder() -> Bool {
        return shouldResignFirstResponder
    }
}

protocol EventDetailInfoProvider {
    func passScheduleToLeftController() -> Void
    func reloadSchedule() -> Void
}

class EventDetailViewController: UITableViewController {
    
    var closeButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    var delegate: CollectionScheduleViewControllerDelegate!
    var sectionHeader: EventDetailHeaderView!
    var noteTextView: NoteTextView!
    var noteText = String()
    var displayedEvent: Event!
    var currentSchedule: Shedule!
    var indexPath: IndexPath!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Information
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatSkyBlue()]
        
        // NAvigatiob bar:
        closeButton = UIBarButtonItem(title: AppStrings.Done, style: .plain, target: self, action: #selector(EventDetailViewController.closeController(_:)))
        navigationItem.leftBarButtonItem = closeButton
        if displayedEvent.isCustom {
            deleteButton = UIBarButtonItem(title: AppStrings.Delete, style: .plain, target: self, action: #selector(EventDetailViewController.deleteEvent))
            deleteButton.tintColor = UIColor.red()
            navigationItem.rightBarButtonItem = deleteButton
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailInfoTitleCell", for: indexPath) as! EventDetailInfoTitleCell
        
        // displaying subject, subject's type and auditory:
        if (indexPath as NSIndexPath).section == 0 {
            
            switch (indexPath as NSIndexPath).row {
                
            case 0:
                cell.eventTitleView.text = currentSchedule.subjects[displayedEvent.subject_id]?.fullTitle
                cell.eventTitleView.font = UIFont.systemFont(ofSize: 22)
                cell.eventTitleView.textAlignment = .center
                if cell.eventTitleView.contentSize.height > cell.eventTitleView.frame.height {
                    cell.eventTitleView.isScrollEnabled = true
                } else {
                    cell.eventTitleView.isScrollEnabled = false
                }
                return cell
            case 1:
                cell.eventTitleView.text = currentSchedule.types[displayedEvent.type]?.full_name
                cell.eventTitleView.textAlignment = .center
                cell.eventTitleView.font = UIFont.systemFont(ofSize: 18)
                cell.eventTitleView.isScrollEnabled = false
            case 2:
                cell.eventTitleView.text = "\(AppStrings.Audytori) \(displayedEvent.auditory)"
                cell.eventTitleView.font = UIFont.systemFont(ofSize: 18)
                cell.eventTitleView.textAlignment = .center
                cell.eventTitleView.isScrollEnabled = false
            default: let cell = UITableViewCell()
                return cell
            }
        }
            
            // displaying teacher:
        else if (indexPath as NSIndexPath).section == 1 {
            if !displayedEvent.teachers.isEmpty {
                cell.eventTitleView.text = currentSchedule.teachers[String(displayedEvent.teachers[0])]?.full_name
            }
            cell.eventTitleView.font = UIFont.systemFont(ofSize: 18)
            cell.eventTitleView.textAlignment = .center
            return cell
            
            // displaying groups:
        } else if (indexPath as NSIndexPath).section == 2 {
            
            var groupsText = String()
            
            for groupId in displayedEvent.groups {
                groupsText.append(currentSchedule.groups[String(groupId)]!)
                groupsText.append(", ")
            }
            for _ in 0...1 {
                groupsText.remove(at: groupsText.index(before: groupsText.endIndex))
            }
            
            cell.eventTitleView.text = groupsText
            cell.eventTitleView.font = UIFont.systemFont(ofSize: 18)
            cell.eventTitleView.textAlignment = .center
            
            // notes' textView:
        } else {
            if currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) == nil {
                cell.eventTitleView.text = AppStrings.AddNote
                cell.eventTitleView.textColor = UIColor.lightGray()
            } else {
                cell.eventTitleView.text = currentSchedule.getNoteWithTokenId(displayedEvent.getEventId)!.text
            }
            cell.eventTitleView.isEditable = true
            cell.eventTitleView.font = UIFont.systemFont(ofSize: 18)
            cell.eventTitleView.textColor = UIColor.darkGray()
            cell.eventTitleView.delegate = self
            noteTextView = cell.eventTitleView
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate:
    
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
            return 100
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        sectionHeader = EventDetailHeaderView(frame: tableView.rectForHeader(inSection: section))
        sectionHeader.saveNoteButton.addTarget(EventDetailViewController(), action: #selector(EventDetailViewController.saveNoteButtonTaped(_:)), for: .touchUpInside)
        sectionHeader.configure(section)
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
    
    // MARK: Sub-methods:
    
    func closeController(_ sender: UIBarButtonItem) {
        if noteTextView != nil {
        noteTextView.shouldResignFirstResponder = true
        noteTextView.resignFirstResponder()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNewSchedule() {
        currentSchedule = delegate.shedule
    }
    
    func saveNoteButtonTaped(_ sender: UIButton) {
        noteTextView.shouldResignFirstResponder = true
        // add new note:
        let converter = DateFormatter()
        converter.dateStyle = .short
        if currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) == nil {
              let newNote = Note(idToken: "\(displayedEvent.subject_id)\(displayedEvent.start_time)", coupledEventTitle: currentSchedule.subjects[displayedEvent.subject_id]!.briefTitle, creationDate: converter.string(from: Date(timeIntervalSince1970: TimeInterval(displayedEvent.start_time))), updatedDate: converter.string(from: Date()), text: noteText)
            currentSchedule.addNewNote(newNote)
            //update existing note:
        } else {
           let updatedNote = currentSchedule.getNoteWithTokenId("\(displayedEvent.subject_id)\(displayedEvent.start_time)")
            if noteText.isEmpty {
                currentSchedule.deleteNoteWithId(updatedNote!.idToken)
            } else {
                updatedNote!.text = noteText
                updatedNote!.updateDate = converter.string(from: Date())
            }
        }
        
        currentSchedule.saveShedule()
        delegate.passScheduleToLeftController()

        
        noteTextView.resignFirstResponder()
        sectionHeader.hideSaveButton()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.reloadNotification), object: nil)
        // done animation:
        SVProgressHUD.setInfoImage(UIImage(named: "tableBookmark"))
        DispatchQueue.main.async(execute: {
            SVProgressHUD.showInfo(withStatus: AppStrings.Saved)
        })
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.after(when: delayTime) {
            SVProgressHUD.dismiss()
        }
        noteTextView.textColor = UIColor.darkGray()
    }
    
    func deleteEvent() {
        
        //delete note:
        _ = currentSchedule.deleteNoteWithId(displayedEvent.getEventId)
        
        //delete event from shedule.days /
        //delete event from custom data:
        currentSchedule.deleteCustomEvent(event: displayedEvent)
        
        // delete event from eventcache:
        currentSchedule.deleteEventFromCache(indexPath: indexPath, event: displayedEvent)
        
        // delete teacher/ type/ subject/ group/ from shedule if needed:
        
        //teacher:
        currentSchedule.deleteTeacherIfUnused(id: String(displayedEvent.teachers[0]))
        
        //type:
        currentSchedule.deleteTypeIfUnused(id: displayedEvent.type)
        
        //subject:
        currentSchedule.deleteSubjectIfUnused(id: displayedEvent.subject_id)
        
        //groups:
        currentSchedule.deleteGroupIfUnused(id: String(displayedEvent.groups[0]))
        
        // save schedule:
        currentSchedule.saveShedule()
        NotificationCenter.default.post(name: NSNotification.Name(AppData.reloadTableView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(AppData.reloadCollectionView), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}


    // MARK: - UITextView Delegate



extension EventDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolderTeext = AppStrings.AddNote
        if textView.text == placeHolderTeext {
            textView.text = ""
        }
        textView.textColor = UIColor.black()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        noteTextView.shouldResignFirstResponder = true
        textView.resignFirstResponder()
        if textView.text.isEmpty {
            textView.text = AppStrings.AddNote
            textView.textColor = UIColor.lightGray()
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
