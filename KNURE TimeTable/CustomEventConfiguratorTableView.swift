//
//  CustomEventConfiguratorTableView.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 7/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

struct SheduleData {
    var id: String
    var value: String
}

enum CustomField: Int {
    case teacher = 0
    case type = 1
    case auditory = 2
    case subject = 3
    case groupe = 4
}

class CustomEventFieldCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

class CustomEventFieldCustomCell: UITableViewCell {

    @IBOutlet weak var titleTextView: UITextView!
}

class CustomEventConfiguratorTableView: UITableViewController {
    
    var delegate: CustomEventTableViewControllerDelegate!
    var field: CustomField!
    var dataSource = [SheduleData]()
    var placeholderText = String()
    var sectionHeader: EventDetailHeaderView!
    var textViewText = String()
    
    // MARK: - Lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()

        // Perform data Source:
        
        // parse teachers:
        if field == .teacher {
            navigationItem.title = AppStrings.Teachers
            placeholderText = AppStrings.Teacher
            dataSource.removeAll()
            dataSource.append(SheduleData(id: "-1", value: "-"))
            for (key, value) in delegate.shedule.teachers {
                if !dataSourceContains(value: value.short_name) {
                    dataSource.insert(SheduleData(id: key, value: value.short_name), at: 0)
                }
            }
        }
        
        //parse types:
        if field == .type {
            navigationItem.title = AppStrings.type
            placeholderText = AppStrings.type
            dataSource.removeAll()
            dataSource.append(SheduleData(id: "-1", value: AppStrings.customType))
            for (key, value) in delegate.shedule.types {
                if !dataSourceContains(value: value.full_name) {
                    dataSource.insert(SheduleData(id: key, value: value.full_name), at: 0)
                }
            }
        }
        
        // Auditory:
        if field == .auditory {
            navigationItem.title = AppStrings.Audytori
            placeholderText = AppStrings.Audytori
            dataSource.removeAll()
        }
        
        //parse subjects:
        if field == .subject {
            navigationItem.title = AppStrings.subject
            placeholderText = AppStrings.subject
            dataSource.removeAll()
            dataSource.append(SheduleData(id: "-1", value: AppStrings.customEvent))
            for (key, value) in delegate.shedule.subjects {
                if !dataSourceContains(value: value.fullTitle) {
                    dataSource.insert(SheduleData(id: key, value: value.fullTitle), at: 0)
                }
            }
        }
        
        //parse groups:
        if field == .groupe {
            navigationItem.title = AppStrings.group
            placeholderText = AppStrings.group
            dataSource.removeAll()
            dataSource.append(SheduleData(id: "-1", value: "-"))
            for (key, value) in delegate.shedule.groups {
                if !dataSourceContains(value: value) {
                    dataSource.insert(SheduleData(id: key, value: value), at: 0)
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataSource.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventFieldCell") as! CustomEventFieldCell
            
            cell.titleLabel.text = dataSource[indexPath.row].value
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomEventFieldCustomCell") as! CustomEventFieldCustomCell
            cell.titleTextView.textColor = UIColor.darkGray()
            cell.titleTextView.text = placeholderText
            cell.titleTextView.delegate = self
            return cell
        }
    }
    
    // MARK: - TableView delegate:
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        sectionHeader = EventDetailHeaderView(frame: tableView.rectForHeader(inSection: section))
        sectionHeader.saveNoteButton.addTarget(self, action: #selector(CustomEventConfiguratorTableView.saveButtomTapped), for: .touchUpInside)
        sectionHeader.configure(4) // 4 - "other" code
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        if field == .teacher {
            delegate.customEvent.teachers[0] = Int(dataSource[indexPath.row].id)!
        } else if field == .type {
            delegate.customEvent.type = dataSource[indexPath.row].id
        } else if field == .subject {
            delegate.customEvent.subject_id = dataSource[indexPath.row].id
        } else if field == .groupe {
            delegate.customEvent.groups[0] = Int(dataSource[indexPath.row].id)!
        }
        
        let root = navigationController?.viewControllers[0] as! CustomEventTableViewController
        root.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Sub methods:
    
    func saveButtomTapped() {
        
        //Teacher:
        if field == .teacher {
            //configuring schedule for new value:
            var id = 0
            if delegate.isTeacherAdded {
                id = delegate.shedule.customData.teachers.count
            } else {
                id = delegate.shedule.customData.teachers.count + 1
            }
            delegate.shedule.customData.teachers.updateValue(Teacher(full_name: textViewText , short_name: textViewText), forKey: String(-id))
            delegate.shedule.teachers.updateValue(Teacher(full_name: textViewText , short_name: textViewText), forKey: String(-id))
            delegate.customEvent.teachers[0] = -id
            delegate.isTeacherAdded = true
        }
        
        //Type:
        if field == .type {
            var id = 0
            if delegate.isTypeAdded {
                id = delegate.shedule.customData.types.count
            } else {
                id = delegate.shedule.customData.types.count + 1
            }
            delegate.shedule.customData.types.updateValue(NureType(short_name: textViewText, full_name: textViewText, id: String(-id)), forKey: String(-id))
            delegate.shedule.types.updateValue(NureType(short_name: textViewText, full_name: textViewText, id: String(-id)), forKey: String(-id))
            delegate.customEvent.type = String(-id)
            delegate.isTypeAdded = true
        }
        
        //Subject:
        if field == .subject {
            var id = 0
            if delegate.isSubjectAdded {
                id = delegate.shedule.customData.subjects.count
            } else {
                id = delegate.shedule.customData.subjects.count + 1
            }
            delegate.shedule.customData.subjects.updateValue(Subject(briefTitle: textViewText, fullTitle: textViewText), forKey: String(-id))
            delegate.shedule.subjects.updateValue(Subject(briefTitle: textViewText, fullTitle: textViewText), forKey: String(-id))
            delegate.customEvent.subject_id = String(-id)
            delegate.isSubjectAdded = true
        }
        
        //Group:
        if field == .groupe {
            var id = 0
            if delegate.isGroupAdded {
                id = delegate.shedule.customData.groups.count
            } else {
                id = delegate.shedule.customData.groups.count + 1
            }
            delegate.shedule.customData.groups.updateValue(textViewText, forKey: String(-id))
            delegate.shedule.groups.updateValue(textViewText, forKey: String(-id))
            delegate.customEvent.groups[0] = -id
        }
        
        //Auditory:
        if field == .auditory {
            delegate.customEvent.auditory = textViewText
        }
        
        let root = navigationController?.viewControllers[0] as! CustomEventTableViewController
        root.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func dataSourceContains(value: String) -> Bool {
        for data in dataSource {
            if value == data.value {
                return true
            }
        }
        return false
    }
}


extension CustomEventConfiguratorTableView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
        }
        textView.textColor = UIColor.black()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text.isEmpty {
            textView.text = AppStrings.AddNote
            textView.textColor = UIColor.lightGray()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewText = textView.text
        if !textView.text.isEmpty {
            sectionHeader.showSaveButton()
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}







