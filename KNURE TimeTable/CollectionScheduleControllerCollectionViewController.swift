//
//  CollectionScheduleControllerCollectionViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import ChameleonFramework

private let cellReuseIdentifier = "CollectionViewCell"
private let emptyCellReuseIndentifier = "emptyCellReuseIndentifier"
private let multiCellReuseIndentifier = "multiCellReuseIndentifier"
private let headerReuseIdentifier = "CollectionCell"
private let decorationViewReuseIdentifier = "DecorationViewReuseIdentifier"

@objc protocol CollectionScheduleViewControllerDelegate {
    func presentViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func passScheduleToLeftController() -> Void
    var shedule: Shedule! { get }
    optional var collectionView: UICollectionView? { get }
}

class CollectionScheduleViewController: UICollectionViewController, CollectionScheduleViewControllerDelegate  {
    
    var shedule: Shedule! {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(AppData.scheduleDidReload, object: nil)
            if !shedule.shedule_id.isEmpty {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(self.shedule.shedule_id, forState: .Normal)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(AppStrings.ChooseSchedule, forState: UIControlState.Normal)
                })
            }
        }
    }
    
    //MARK: - Properies:
    
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    let scale = CollectionDecorationView()
    let headerScale = CollectionHeaderView()
    var initialScrollDone = false
    var doubleTapGesture = UITapGestureRecognizer()
    var scaleTapGestureRecognizer = UITapGestureRecognizer()
    var weekScheduleControllerDelegate: TableSheduleControllerDelegate!
    
    //MARK: - Lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = FlatWhite()
        // EmptyDataSource:
        collectionView!.emptyDataSetSource = self
        collectionView!.emptyDataSetDelegate = self
        
        // gesture-recognizers:
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(CollectionScheduleViewController.doubleTapGestureDetected(_:)))
        collectionView?.addGestureRecognizer(doubleTapGesture)
        
        scaleTapGestureRecognizer.addTarget(self, action: #selector(CollectionScheduleViewController.doubleTapGestureDetected(_:)))
        headerScale.addGestureRecognizer(scaleTapGestureRecognizer)
    
        // Register cell classes
        self.collectionView?.registerClass(CollectionScheduleCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView?.registerClass(CollectionScheduleEmptyCell.self, forCellWithReuseIdentifier: emptyCellReuseIndentifier)
        self.collectionView?.registerClass(CollectionScheduleMultiCell.self, forCellWithReuseIdentifier: multiCellReuseIndentifier)
       
        //navigationItem setUp:
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CollectionScheduleViewController.presentLeftMenuViewController(_:)))
        navigationItem.leftBarButtonItem = sideInfoButton
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        button.addTarget(self, action: #selector(CollectionScheduleViewController.showMenu(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        
        // Timescale:
        scale.frame = CGRect(x: 0, y: 0, width: 50, height: collectionView!.contentSize.height)
        scale.configure(collectionView!.bounds.height)
    }
    
    func configureDateScale() {
        //Date scale:
        headerScale.delegate = self
        headerScale.configure(shedule)
    }
    
    override func viewWillAppear(animated: Bool) {
        // set empty data set:
        collectionView?.reloadData()
        if shedule.shedule_id.isEmpty {
            viewDidLayoutSubviews()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // timeScale configuring:
        self.becomeFirstResponder()
        if shedule.shedule_id.isEmpty {
            scale.removeFromSuperview()
            headerScale.removeFromSuperview()
        } else {
            collectionView?.addSubview(scale)
            collectionView?.addSubview(headerScale)
        }
        
        // performing initil scroll:
        if !initialScrollDone {
            let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
            let numberOfdays = firstEventDay.differenceInDaysWithDate(NSDate())
            collectionView?.contentOffset = CGPoint(x: 126 * numberOfdays, y: 0)
            configureDateScale()
            initialScrollDone = true
        }
    }
    
    func showMenu(sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        let menuNavigationController = UINavigationController(rootViewController: shedulesListController)
        menuNavigationController.navigationBar.barTintColor = FlatWhite()
        self.presentViewController(menuNavigationController, animated: true, completion: nil)
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if shedule == nil && shedule.shedule_id.isEmpty{
            return 0
        }
        return shedule.numberOfDaysInSemester()
    }


     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shedule == nil && shedule.shedule_id.isEmpty {
            return 0
        }
        return shedule.numberOfPairsInDay()
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if shedule.eventsCache["\(indexPath.section)\(indexPath.row)"] == nil {
            shedule.performCache()
        }
        let events = shedule.eventsCache["\(indexPath.section)\(indexPath.row)"]!.events
        
        if events.isEmpty {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emptyCellReuseIndentifier, forIndexPath: indexPath) as! CollectionScheduleEmptyCell
            return cell
        }
        if events.count > 1 {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(multiCellReuseIndentifier, forIndexPath: indexPath) as! CollectionScheduleMultiCell
            cell.delegate = self
            cell.configure(events, shedule: shedule)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CollectionScheduleCell
            cell.delegate = self
        cell.configure(events, shedule: shedule)
        return cell
        }
    }
    
    func passScheduleToLeftController() {
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = shedule
    }
}

    // MARK: -  Gestures:

extension CollectionScheduleViewController {
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake{
            performScrollToToday()
            if weekScheduleControllerDelegate != nil {
                weekScheduleControllerDelegate!.performScrollToToday()
            }
        }
    }
    
     func doubleTapGestureDetected(sender: UITapGestureRecognizer) {
        performScrollToToday()
    }
    
    func performScrollToToday() {
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        
        let numberOfdays = firstEventDay.differenceInDaysWithDate(NSDate())
        
        // check for scrolling impossibility.
        if numberOfdays > collectionView!.numberOfSections() || numberOfdays < 0 {
            return
        }
        collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: numberOfdays), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        collectionView?.contentOffset.x -= 50
        collectionView?.contentOffset.y = 0
        
    }
}

    // MARK: - DZNEmptyDataSetSource

extension CollectionScheduleViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "NureTimeTable", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24, weight: 1), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }
}
















