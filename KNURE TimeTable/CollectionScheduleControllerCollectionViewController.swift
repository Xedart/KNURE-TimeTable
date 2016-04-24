//
//  CollectionScheduleControllerCollectionViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "CollectionViewCell"
private let emptyCellReuseIndentifier = "emptyCellReuseIndentifier"
private let multiCellReuseIndentifier = "multiCellReuseIndentifier"
private let headerReuseIdentifier = "CollectionCell"
private let decorationViewReuseIdentifier = "DecorationViewReuseIdentifier"

protocol CollectionScheduleViewControllerDelegate {
    func presentViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func passScheduleToLeftController() -> Void
    var shedule: Shedule! { get }
}

class CollectionScheduleViewController: UICollectionViewController, CollectionScheduleViewControllerDelegate  {
    
    var shedule: Shedule! {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(AppData.scheduleDidReload, object: nil)
            if !shedule.shedule_id.isEmpty {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(self.shedule.shedule_id, forState: .Normal)
                })
            }
        }
    }
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    let scale = CollectionDecorationView()
    var initialScrollDone = false
    var doubleTapGesture = UITapGestureRecognizer()
    var weekScheduleControllerDelegate: TableSheduleControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "назад"// title for back item
        // EmptyDataSource:
        collectionView!.emptyDataSetSource = self
        collectionView!.emptyDataSetDelegate = self
        
        // gesture-recognizer:
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(CollectionScheduleViewController.doubleTapGestureDetected(_:)))
        collectionView?.addGestureRecognizer(doubleTapGesture)
        
        // Register cell classes
        self.collectionView?.registerClass(CollectionScheduleCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView?.registerClass(CollectionScheduleEmptyCell.self, forCellWithReuseIdentifier: emptyCellReuseIndentifier)
        self.collectionView?.registerClass(CollectionScheduleMultiCell.self, forCellWithReuseIdentifier: multiCellReuseIndentifier)
        self.collectionView!.registerClass(CollectionHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: headerReuseIdentifier)
       
        //navigationItem setUp:
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CollectionScheduleViewController.presentLeftMenuViewController(_:)))
        navigationItem.leftBarButtonItem = sideInfoButton
        button.addTarget(self, action: #selector(CollectionScheduleViewController.showMenu(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        
        // Timescale:
        scale.frame = CGRect(x: 0, y: 0, width: 55, height: collectionView!.contentSize.height)
        scale.configure(collectionView!.bounds.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // set empty Data Set:
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
        } else {
            collectionView?.addSubview(scale)
        }
        
        // performing initil scroll:
        if !initialScrollDone {
            let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
            let numberOfdays = firstEventDay.differenceInDaysWithDate(NSDate())
            collectionView?.contentOffset = CGPoint(x: 126 * numberOfdays, y: 0)
            initialScrollDone = true
        }
    }
    
    func showMenu(sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        navigationController?.pushViewController(shedulesListController, animated: true)
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if shedule == nil {
            return 0
        }
        return shedule.numberOfDaysInSemester()
    }


     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shedule == nil {
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
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind("Header", withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! CollectionHeader
        headerView.configure(indexPath.section, shedule: shedule)
        return headerView
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
        collectionView?.contentOffset.x -= 55
        collectionView?.contentOffset.y = 0
        
    }
}

    // MARK: - DZNEmptyDataSetSource

extension CollectionScheduleViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Розклад не обрано", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(20, weight: 1)])
    }
}
















