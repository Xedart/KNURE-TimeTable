//
//  CollectionScheduleControllerCollectionViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "CollectionViewCell"
private let headerReuseIdentifier = "CollectionCell"
private let decorationViewReuseIdentifier = "DecorationViewReuseIdentifier"

class CollectionScheduleViewController: UICollectionViewController  {
    
    var shedule: Shedule! {
        didSet {
            if !initialScrollDone {
            cacheData()
            }
        }
    }
    let scale = CollectionDecorationView()
    var initialScrollDone = false
    var headersCache = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView?.registerClass(CollectionScheduleCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView!.registerClass(CollectionHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: headerReuseIdentifier)
        // delegate:
        if let layout = collectionView?.collectionViewLayout as? ScheduleCollectionLayout {
            layout.delegate = self
        }
        // Time - scale:
        scale.frame = CGRect(x: 0, y: 0, width: 55, height: collectionView!.contentSize.height)
        scale.configure(collectionView!.bounds.height)
        collectionView!.addSubview(scale)
    }
    
    func cacheData() {
        headersCache.removeAll()
        let formatter = NSDateFormatter()
            formatter.dateFormat = "dd.MM"
        for section in 0 ..< self.collectionView!.numberOfSections() {
            let dateStr = formatter.stringFromDate(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * section), sinceDate: NSDate(timeIntervalSince1970: NSTimeInterval(self.shedule.startDayTime))))
            self.headersCache.append("\(dateStr) \(AppData.getDayOfWeek(dateStr))")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !initialScrollDone {
            let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
            let numberOfdays = firstEventDay.differenceInDaysWithDate(NSDate())
            collectionView?.contentOffset = CGPoint(x: 105 * numberOfdays, y: 0)
            initialScrollDone = true
        }
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CollectionScheduleCell
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(self.shedule.startDayTime))
        
        let events = self.shedule.eventInDayWithNumberOfPair(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * indexPath.section), sinceDate: firstEventDay), numberOFPair: indexPath.row + 1)
        if events.isEmpty {
            cell.configureEmptyCell()
            return cell
        }
        cell.configure(events, shedule: shedule)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind("Header", withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! CollectionHeader
        headerView.configure(self.headersCache[indexPath.section])
        return headerView
    }
}

    // MARK: - CollectionScheduleViewControllerDelegate

extension CollectionScheduleViewController: CollectionScheduleViewControllerDelegate {
    
    func eventsTimesInSection(section: Int) -> [CGFloat] {
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        let eventsDay = NSDate(timeInterval: NSTimeInterval(AppData.unixDay * section), sinceDate: firstEventDay)
        var result = [CGFloat]()
        for row in  1...8 {
            let events = self.shedule.eventInDayWithNumberOfPair(eventsDay, numberOFPair: row)
            if !events.isEmpty {
                result.append(CGFloat(row - 1))
            }
        }
        return result
    }
}















