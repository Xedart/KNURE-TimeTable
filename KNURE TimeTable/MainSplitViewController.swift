//
//  MainSplitViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

protocol SheduleControllersInitializer {
    func initializeWithNewShedule()
}

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Properties:
    
    var sheduleNavigationController = UINavigationController()
    let button = TitleViewButton()
    var scheduleTableController: TableSheduleController!
    
    // MARK: - ViewController lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableController = viewControllers[0] as! TableSheduleController
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
       
        let sheduleListController = ShedulesListTableViewController()
        sheduleListController.delegate = self
        sheduleNavigationController = UINavigationController(rootViewController: sheduleListController)
        sheduleNavigationController.modalPresentationStyle = .Popover
        sheduleNavigationController.preferredContentSize = CGSize(width: 350, height: 500)
        
        navigationItem.titleView = button
        button.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)

// loading and transfering shedule provided by default:
        initializeWithNewShedule()
// displaying:
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
    }
    
    // MARK: - Methods:
    
    func showMenu(sender: UIButton) {
        let popoverMenuViewController = sheduleNavigationController.popoverPresentationController
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.permittedArrowDirections = .Up
        popoverMenuViewController?.sourceView = navigationItem.titleView
        popoverMenuViewController?.backgroundColor = UIColor.whiteColor()
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 10,
            width: button.bounds.width,
            height: button.bounds.height)
            presentViewController(sheduleNavigationController, animated: true, completion: nil)
    }
    /*
    func saveShedule() {
        print("\(Shedule().urlPath.path!)/ex")
        let save = NSKeyedArchiver.archiveRootObject(shedule, toFile: "\(Shedule().urlPath.path!)/ex")
        if !save {
            print("Error when saving")
        }
    }
    */
    func loadShedule(sheduleId: String) -> Shedule {
        return NSKeyedUnarchiver.unarchiveObjectWithFile("\(Shedule().urlPath.path!)/\(sheduleId)") as! Shedule
    }
}

    // MARK: - SheduleControllersInitializer conformance:

extension MainSplitViewController: SheduleControllersInitializer {
    func initializeWithNewShedule() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultKey = defaults.objectForKey(AppData.defaultScheduleKey) as? String {
            scheduleTableController.shedule = loadShedule(defaultKey)
            scheduleTableController.tableView.reloadData()
            // TODO: add collection controller init here
            button.setTitle(defaultKey, forState: UIControlState.Normal)
        } else {
            scheduleTableController.shedule = Shedule()
            scheduleTableController.tableView.reloadData()
            // TODO: add collection controller init here
        }
    }
}


    // MARK: - pop all vieewCOntroller to root when dissmissing popOver:

extension MainSplitViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        sheduleNavigationController.popToRootViewControllerAnimated(false)
    }
}











