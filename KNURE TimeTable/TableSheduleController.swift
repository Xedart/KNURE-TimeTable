//
//  TableSheduleController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class TableSheduleController: UITableViewController {
    
    var dataSource: Shedule!

    override func viewDidLoad() {
        super.viewDidLoad()
        let event = Event(subject_id: "Subj", start_time: 123, end_time: 213, type: 1, numberOf_pair: 1, auditory: 222, teachers: [11], groups: [311])
        let events = Events(events: [event])
        
        let groups = Groups(groups: ["das": "asds"])
        
        let teacher = Teacher(full_name: "ARTHUR", short_name: "SDS")
        let teachers = Teachers(teachers: ["asda": teacher])
        
        let subject = Subject(briefTitle: "CS", fullTitle: "fullTitle")
        let subjects = Subjects(subjects: ["sad":subject])
        
        let type = Type(short_name: "short_name", full_name: "full_name", type: "type")
        let types = Types(types: ["3ds": type])
        
        dataSource = Shedule(shedule_id: "KN-14-2", events: events, groups: groups, teachers: teachers, subjects: subjects, types: types)
        
    }
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableSheduleCell", forIndexPath: indexPath) as! TableSheduleCell
        
        
        cell.startTime.text = String(dataSource.events[0].start_time)

        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableSheduleHeader(section: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
