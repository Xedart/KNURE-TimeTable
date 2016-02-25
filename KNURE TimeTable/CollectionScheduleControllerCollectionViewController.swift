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
    
    var shedule: Shedule!
    let scale = CollectionDecorationView()
    var initialScrollDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
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
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        let eventsDay = NSDate(timeInterval: NSTimeInterval(AppData.unixDay * section), sinceDate: firstEventDay)
        let pairsInDay = shedule.eventsInDay(eventsDay)
        return pairsInDay.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CollectionScheduleCell
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        let events = shedule.eventsInDay(NSDate(timeInterval: NSTimeInterval(AppData.unixDay * indexPath.section), sinceDate: firstEventDay))
        let eventTitle = shedule.subjects[events[indexPath.row].subject_id]!.briefTitle
        let eventType = shedule.types[events[indexPath.row].type]!.short_name
        let auditory = events[indexPath.row].auditory
        cell.configure(eventTitle, eventType: eventType, auditory: auditory)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind("Header", withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! CollectionHeader
        headerView.configure(indexPath.section, startDay: shedule.startDayTime)
        return headerView
    }
}

    // MARK: - CollectionScheduleViewControllerDelegate

extension CollectionScheduleViewController: CollectionScheduleViewControllerDelegate {
    
    func eventsTimesInSection(section: Int) -> [CGFloat] {
        let firstEventDay = NSDate(timeIntervalSince1970: NSTimeInterval(shedule.startDayTime))
        let eventsDay = NSDate(timeInterval: NSTimeInterval(AppData.unixDay * section), sinceDate: firstEventDay)
        let pairsInDay = shedule.eventsInDay(eventsDay)
        var result = [CGFloat]()
        for pair in pairsInDay {
            result.append(CGFloat(pair.numberOf_pair - 1))
        }
        return result
    }
}















