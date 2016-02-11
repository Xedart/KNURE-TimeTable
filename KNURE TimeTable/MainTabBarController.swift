//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var shedule: Shedule!
    var sheduleId = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let event = Event(subject_id: "2045851", start_time: 1455268500, end_time: 1455187800, type: 1, numberOf_pair: 1, auditory: 222, teachers: [11], groups: [311])
        let event2 = Event(subject_id: "2045851", start_time: 1455268500, end_time: 1455187800, type: 1, numberOf_pair: 2, auditory: 222, teachers: [11], groups: [311])
        let events = Events(events: [event, event2])
        
        let groups = Groups(groups: ["das": "asds"])
        
        let teacher = Teacher(full_name: "ARTHUR", short_name: "SDS")
        let teachers = Teachers(teachers: ["asda": teacher])
        
        let subject = Subject(briefTitle: "CS", fullTitle: "Технологіі комп\"ютерного проектування")
        let subjects = Subjects(subjects: ["2045851":subject])
        
        let type = Type(short_name: "short_name", full_name: "full_name", type: "type")
        let types = Types(types: [1: type])
        
        shedule = Shedule(shedule_id: "KN-14-2", events: events, groups: groups, teachers: teachers, subjects: subjects, types: types)
        let navigationController = viewControllers![0] as! UINavigationController
        let tableShedule = navigationController.viewControllers[0] as! TableSheduleController
        tableShedule.shedule = self.shedule

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
