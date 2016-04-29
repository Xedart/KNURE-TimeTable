//
//  EventDetailViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/18/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import SVProgressHUD
import ChameleonFramework

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
    var delegate: CollectionScheduleViewControllerDelegate!
    var sectionHeader: EventDetailHeaderView!
    var noteTextView: NoteTextView!
    var noteText = String()
    var displayedEvent: Event!
    var currentSchedule: Shedule!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AppStrings.Information
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatSkyBlue()]
        
        closeButton = UIBarButtonItem(title: AppStrings.Done, style: .Plain, target: self, action: #selector(EventDetailViewController.closeController(_:)))
        navigationItem.leftBarButtonItem = closeButton
        
        // adding observer notification for schedule:
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventDetailViewController.getNewSchedule), name: AppData.scheduleDidReload, object: nil)
        // noteTextViewNotifications:
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventDetailViewController.openNoteTextView), name: AppData.openNoteTextView, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventDetailViewController.closeNoteTextView), name: AppData.blockNoteTextView, object: nil)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventDetailInfoTitleCell", forIndexPath: indexPath) as! EventDetailInfoTitleCell
        
        // displaying subject, subject's type and auditory:
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                cell.eventTitleView.text = currentSchedule.subjects[displayedEvent.subject_id]!.fullTitle
                cell.eventTitleView.font = UIFont.systemFontOfSize(22)
                cell.eventTitleView.textAlignment = .Center
                if cell.eventTitleView.contentSize.height > cell.eventTitleView.frame.height {
                    cell.eventTitleView.scrollEnabled = true
                } else {
                    cell.eventTitleView.scrollEnabled = false
                }
                return cell
            case 1:
                cell.eventTitleView.text = currentSchedule.types[displayedEvent.type]!.full_name
                cell.eventTitleView.textAlignment = .Center
                cell.eventTitleView.font = UIFont.systemFontOfSize(18)
                cell.eventTitleView.scrollEnabled = false
            case 2:
                cell.eventTitleView.text = "\(AppStrings.Audytori) \(displayedEvent.auditory)"
                cell.eventTitleView.font = UIFont.systemFontOfSize(18)
                cell.eventTitleView.textAlignment = .Center
                cell.eventTitleView.scrollEnabled = false
            default: let cell = UITableViewCell()
                return cell
            }
        }
            
            // displaying teacher:
        else if indexPath.section == 1 {
            if !displayedEvent.teachers.isEmpty {
                cell.eventTitleView.text = currentSchedule.teachers[String(displayedEvent.teachers[0])]!.full_name
            }
            cell.eventTitleView.font = UIFont.systemFontOfSize(18)
            cell.eventTitleView.textAlignment = .Center
            return cell
            
            // displaying groups:
        } else if indexPath.section == 2 {
            
            var groupsText = String()
            
            for groupId in displayedEvent.groups {
                groupsText.appendContentsOf(currentSchedule.groups[String(groupId)]!)
                groupsText.appendContentsOf(", ")
            }
            for _ in 0...1 {
                groupsText.removeAtIndex(groupsText.endIndex.predecessor())
            }
            
            cell.eventTitleView.text = groupsText
            cell.eventTitleView.font = UIFont.systemFontOfSize(18)
            cell.eventTitleView.textAlignment = .Center
            
            // notes' textView:
        } else {
            if currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) == nil {
                cell.eventTitleView.text = AppStrings.AddNote
                cell.eventTitleView.textColor = UIColor.lightGrayColor()
            } else {
                cell.eventTitleView.text = currentSchedule.getNoteWithTokenId(displayedEvent.getEventId)!.text
            }
            cell.eventTitleView.editable = true
            cell.eventTitleView.font = UIFont.systemFontOfSize(18)
            cell.eventTitleView.textColor = UIColor.darkGrayColor()
            cell.eventTitleView.delegate = self
            noteTextView = cell.eventTitleView
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate:
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 100
            } else {
                return 50
            }
        }
        else if indexPath.section == 1 {
            return 60
        } else if indexPath.section == 2 {
            return 60
        } else if indexPath.section == 3 {
            return 100
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        sectionHeader = EventDetailHeaderView(frame: tableView.rectForHeaderInSection(section))
        sectionHeader.configure(section)
        return sectionHeader
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 40
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: Sub-methods:
    
    func closeController(sender: UIBarButtonItem) {
        if noteTextView != nil {
        noteTextView.shouldResignFirstResponder = true
        noteTextView.resignFirstResponder()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getNewSchedule() {
        currentSchedule = delegate.shedule
    }
    
    func saveNoteButtonTaped(sender: UIButton) {
        noteTextView.shouldResignFirstResponder = true
        // add new note:
        let converter = NSDateFormatter()
        converter.dateStyle = .ShortStyle
        if currentSchedule.getNoteWithTokenId(displayedEvent.getEventId) == nil {
              let newNote = Note(idToken: "\(displayedEvent.subject_id)\(displayedEvent.start_time)", coupledEventTitle: currentSchedule.subjects[displayedEvent.subject_id]!.briefTitle, creationDate: converter.stringFromDate(NSDate()), updatedDate: converter.stringFromDate(NSDate()), text: noteText)
            currentSchedule.addNewNote(newNote)
            //update existing note:
        } else {
           let updatedNote = currentSchedule.getNoteWithTokenId("\(displayedEvent.subject_id)\(displayedEvent.start_time)")
            if noteText.isEmpty {
                currentSchedule.deleteNoteWithId(updatedNote!.idToken)
            } else {
                updatedNote!.text = noteText
                updatedNote!.updateDate = converter.stringFromDate(NSDate())
            }
        }
        
        currentSchedule.saveShedule()
        delegate.passScheduleToLeftController()

        
        noteTextView.resignFirstResponder()
        sectionHeader.hideSaveButton()
        NSNotificationCenter.defaultCenter().postNotificationName(AppData.reloadNotification, object: nil)
        // done animation:
        SVProgressHUD.setInfoImage(UIImage(named: "DoneImage"))
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.showInfoWithStatus(AppStrings.Saved)
        })
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
        noteTextView.textColor = UIColor.darkGrayColor()
    }
}


    // MARK: - UITextView Delegate



extension EventDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let placeHolderTeext = AppStrings.AddNote
        if textView.text == placeHolderTeext {
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        noteTextView.shouldResignFirstResponder = true
        textView.resignFirstResponder()
        if !(textView.text!.isEmpty) {
           sectionHeader.showSaveButton()
        } else {
           sectionHeader.hideSaveButton()
        }
        if textView.text.isEmpty {
            textView.text = AppStrings.AddNote
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
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