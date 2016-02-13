//
//  MainSplitViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Data-source
    
    var shedule: Shedule!
    let infoNavigationController = UINavigationController(rootViewController: ShedulesListTableViewController())
    let button = UIButton()
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let event = Event(subject_id: "id", start_time: 1455318795, end_time: 1455268500, type: "1", numberOfPair: 1, auditory: 231, teachers: [11], groups: [112])
        let event2 = Event(subject_id: "id", start_time: 1455318795, end_time: 1455268500, type: "1", numberOfPair: 2, auditory: 231, teachers: [11], groups: [112])
        let events = [event, event2]
        
        let groups = ["212": "KN-14-2"]
        
        let teacher = Teacher(full_name: "ARTHUR", short_name: "SDS")
        let teachers = ["1002": teacher]
        
        let subject = Subject(briefTitle: "CS", fullTitle: "Технологіі комп\"ютерного проектування")
        let subjects = ["id": subject]
        
        let type = Type(short_name: "short_name", full_name: "Лекцыя")
        let types =  ["1": type]
        
        shedule = Shedule(shedule_id: "KN-14-2", events: events, groups: groups, teachers: teachers, subjects: subjects, types: types)
        */
       
        infoNavigationController.modalPresentationStyle = .Popover
        infoNavigationController.preferredContentSize = CGSize(width: 350, height: 500)
        
        
        button.setTitle("EXAMPLE", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)
        
        navigationItem.titleView = button
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            shedule = loadShedule(defaultKey)
        } else {
            shedule = Shedule()
        }
        let tableShedule = viewControllers[0] as! TableSheduleController
        tableShedule.shedule = self.shedule
        
// displaying:
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
    }
    
    func showMenu(sender: UIButton) {
        let popoverMenuViewController = infoNavigationController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Up
        popoverMenuViewController?.sourceView = navigationItem.titleView
        popoverMenuViewController?.backgroundColor = UIColor.whiteColor()
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 10,
            width: button.bounds.width,
            height: button.bounds.height)
            presentViewController(infoNavigationController, animated: true, completion: nil)
    }
    
    func saveShedule() {
        print("\(Shedule().urlPath.path!)/ex")
        let save = NSKeyedArchiver.archiveRootObject(shedule, toFile: "\(Shedule().urlPath.path!)/ex")
        if !save {
            print("Error when saving")
        }
    }
    
    func loadShedule(sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObjectWithFile("\(Shedule().urlPath.path!)/\(sheduleId)") as! Shedule
    }

    
}
