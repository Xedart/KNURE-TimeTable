//
//  CustomEventTableViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 7/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
//import ChameleonFramework

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

class CustomEventTableViewController: UITableViewController, CustomEventTableViewControllerDelegate {
    
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
        closeButton = UIBarButtonItem(title: AppStrings.cancel, style: .plain, target: self, action: #selector(CustomEventTableViewController.close))
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
        customEvent = Event(subject_id: "-1", start_time: delegate.shedule.startDayTime + (indexPath.section * AppData.unixDay) + indexPath.row + delegate.shedule.customData.events.count, end_time: delegate.shedule.startDayTime + (indexPath.section * AppData.unixDay) + 5700, type: "-1", numberOfPair: indexPath.row + 1, auditory: "-", teachers: [-1], groups: [-1], isCustom: true)
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
        
        // save note:
        if noteTextView!.text != AppStrings.AddNote && noteTextView!.text != "" {
            let newNote = Note(idToken: "\(customEvent.subject_id)\(customEvent.start_time)", coupledEventTitle: delegate.shedule.subjects[customEvent.subject_id]!.briefTitle, creationDate: formatter.string(from: Date(timeIntervalSince1970: TimeInterval(customEvent.start_time))), updatedDate: formatter.string(from: Date()), text: noteTextView.text!)
            delegate.shedule.addNewNote(newNote)
        }
        
        delegate.shedule.saveShedule()
        delegate.passScheduleToLeftController()
        
        //reload view:
        delegate.collectionView!?.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(AppData.reloadTableView), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventTableViewController", for: indexPath) as! CustomEventTableViewControllerCell
            if UIDevice.current().userInterfaceIdiom == .pad {
                cell.titleLabel.font = UIFont.systemFont(ofSize: 18.0)
                let widthConstraint = NSLayoutConstraint(item: cell.titleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 180)
                view.addConstraint(widthConstraint)
            }
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = AppStrings.Teacher
            cell.DisplayedChoiseLabel.text = delegate.shedule.teachers[String(customEvent.teachers[0])]!.short_name
        case 1:
            cell.titleLabel.text = AppStrings.type
            cell.DisplayedChoiseLabel.text = delegate.shedule.types[customEvent.type]!.full_name
        case 2:
            cell.titleLabel.text = AppStrings.Audytori
            cell.DisplayedChoiseLabel.text = customEvent.auditory
        case 3:
            cell.titleLabel.text = AppStrings.subject
            cell.DisplayedChoiseLabel.text = delegate.shedule.subjects[customEvent.subject_id]?.fullTitle
        case 4:
            cell.titleLabel.text = AppStrings.group
            cell.DisplayedChoiseLabel.text = delegate.shedule.groups[String(customEvent.groups.first!)]
        default:
            cell.titleLabel.text = "default"
        }

        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventTableViewControllerNoteCell", for: indexPath) as! CusomEventTableVIewControllerNoteCell
            cell.noteTextView.text = AppStrings.AddNote
            cell.noteTextView.textColor = UIColor.darkGray()
            cell.noteTextView.delegate = self
            noteTextView = cell.noteTextView
            return cell
            
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let destionation = segue.destinationViewController as! CustomEventConfiguratorTableView
        destionation.delegate = self
        destionation.field = CustomField(rawValue: tableView.indexPathForSelectedRow!.row)
    }
}

   //MARK: - TExtViewDelegate:

extension CustomEventTableViewController: UITextViewDelegate {
    
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
    
    func openNoteTextView() {
        noteTextView?.shouldResignFirstResponder = true
    }
    
    func closeNoteTextView() {
        noteTextView?.shouldResignFirstResponder = false
    }
}










