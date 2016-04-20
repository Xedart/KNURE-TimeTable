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

protocol EventDetailInfoContainer {
    var currentSchedule: Shedule! { get set }
    var displayedEvent: Event! { get }
}

class EventDetailViewController: UITableViewController {
    
    var closeButton: UIBarButtonItem!
    var delegate: EventDetailInfoContainer!
    var sectionHeader: EventDetailHeaderView!
    var noteTextView: UITextView!
    var noteText = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Інформація"
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: FlatSkyBlue()]
        
        closeButton = UIBarButtonItem(title: "Готово", style: .Plain, target: self, action: #selector(EventDetailViewController.closeController(_:)))
        navigationItem.leftBarButtonItem = closeButton
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
                cell.eventTitleView.text =  delegate.currentSchedule.subjects[delegate.displayedEvent.subject_id]!.fullTitle
                cell.eventTitleView.font = UIFont.systemFontOfSize(22)
                cell.eventTitleView.textAlignment = .Center
                if cell.eventTitleView.contentSize.height > cell.eventTitleView.frame.height {
                    cell.eventTitleView.scrollEnabled = true
                } else {
                    cell.eventTitleView.scrollEnabled = false
                }
                return cell
            case 1:
                cell.eventTitleView.text = delegate.currentSchedule.types[delegate.displayedEvent.type]!.full_name
                cell.eventTitleView.textAlignment = .Center
                cell.eventTitleView.font = UIFont.systemFontOfSize(18)
                cell.eventTitleView.scrollEnabled = false
            case 2:
                cell.eventTitleView.text = "Аудиторія \(delegate.displayedEvent.auditory)"
                cell.eventTitleView.font = UIFont.systemFontOfSize(18)
                cell.eventTitleView.textAlignment = .Center
                cell.eventTitleView.scrollEnabled = false
            default: let cell = UITableViewCell()
                return cell
            }
        }
            
            // displaying teacher:
        else if indexPath.section == 1 {
            if !delegate.displayedEvent.teachers.isEmpty {
                cell.eventTitleView.text = delegate.currentSchedule.teachers[String(delegate.displayedEvent.teachers[0])]!.full_name
            }
            cell.eventTitleView.font = UIFont.systemFontOfSize(18)
            cell.eventTitleView.textAlignment = .Center
            return cell
            
            // displaying groups:
        } else if indexPath.section == 2 {
            
            var groupsText = String()
            
            for groupId in delegate.displayedEvent.groups {
                groupsText.appendContentsOf(delegate.currentSchedule.groups[String(groupId)]!)
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
            if delegate.displayedEvent.note.isEmpty {
                cell.eventTitleView.text = " Додати запис"
                cell.eventTitleView.textColor = UIColor.lightGrayColor()
            } else {
                cell.eventTitleView.text = delegate.displayedEvent.note
            }
            cell.eventTitleView.editable = true
            cell.eventTitleView.font = UIFont.systemFontOfSize(18)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNoteButtonTaped(sender: UIButton) {
        delegate.displayedEvent.note = noteText
        delegate.currentSchedule.saveShedule()
        
        noteTextView.resignFirstResponder()
        sectionHeader.hideSaveButton()
        
        // done animation:
        SVProgressHUD.setInfoImage(UIImage(named: "DoneImage"))
        dispatch_async(dispatch_get_main_queue(), {
            SVProgressHUD.showInfoWithStatus("Збережено!")
        })
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
    }
}


    // MARK: - UITextView Delegate



extension EventDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let placeHolderTeext = " Додати запис"
        if textView.text == placeHolderTeext {
            textView.text = ""
        }
        textView.textColor = UIColor.blackColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
        if !(textView.text!.isEmpty) {
           sectionHeader.showSaveButton()
        } else {
           sectionHeader.hideSaveButton()
        }
        if textView.text.isEmpty {
            textView.text = " Додати запис"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        noteText = textView.text
        if !(textView.text!.isEmpty) {
           sectionHeader.showSaveButton()
        } else {
           sectionHeader.hideSaveButton()
        }
    }
}









