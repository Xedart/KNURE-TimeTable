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

struct EventCache {
    var events = [Event]()
    init(events: [Event]) {
        self.events = events
    }
}

class CollectionScheduleViewController: UICollectionViewController  {
    
    var shedule: Shedule! {
        didSet {
            cacheData()
            if !shedule.shedule_id.isEmpty {
                dispatch_async(dispatch_get_main_queue(), {
                    self.button.setTitle(self.shedule.shedule_id, forState: .Normal)
                })
            }
            if !initialScrollDone {
               
            }
        }
    }
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    let scale = CollectionDecorationView()
    var initialScrollDone = false
    var rowsCache = [String: EventCache]()
    var doubleTapGesture = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = sideInfoButton
        button.addTarget(self, action: #selector(CollectionScheduleViewController.showMenu(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        
        // Time - scale:
        scale.frame = CGRect(x: 0, y: 0, width: 55, height: collectionView!.contentSize.height)
        scale.configure(collectionView!.bounds.height)
        collectionView!.addSubview(scale)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    func cacheData() {
        rowsCache.removeAll()
        let formatter = NSDateFormatter()
            formatter.dateFormat = "dd.MM"
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(self.shedule.startDayTime))
        for section in 0 ..< self.collectionView!.numberOfSections() {
           
            for row in 0..<self.collectionView!.numberOfItemsInSection(section) {
                let events = self.shedule.eventInDayWithNumberOfPair(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * section), sinceDate: firstEventDay), numberOFPair: row + 1)
                rowsCache["\(section)\(row)"] = EventCache(events: events)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        if shedule.shedule_id.isEmpty {
            return 0
        }
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        let lastDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.endDayTime))
        let numberOfdays = firstEventDay.differenceInDaysWithDate(lastDay) + 1
        return numberOfdays == 1 ? 0 : numberOfdays
    }


     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shedule.shedule_id.isEmpty {
            return 0
        }
        return 8
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if rowsCache["\(indexPath.section)\(indexPath.row)"] == nil {
            cacheData()
        }
        let events = rowsCache["\(indexPath.section)\(indexPath.row)"]!.events
        
        if events.isEmpty {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emptyCellReuseIndentifier, forIndexPath: indexPath) as! CollectionScheduleEmptyCell
            return cell
        }
        if events.count > 1 {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier(multiCellReuseIndentifier, forIndexPath: indexPath) as! CollectionScheduleMultiCell
            cell.configure(events, shedule: shedule)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CollectionScheduleCell
        cell.configure(events, shedule: shedule)
        return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind("Header", withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! CollectionHeader
        headerView.configure(indexPath.section, shedule: shedule)
        return headerView
    }
}

    // MARK: -  Gestures:

extension CollectionScheduleViewController {
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        performScrollToToday()
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
    }
}














