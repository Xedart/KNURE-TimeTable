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

class CollectionScheduleViewController: UICollectionViewController {
    
    var shedule: Shedule!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.registerClass(CollectionScheduleCell.self, forCellWithReuseIdentifier: cellReuseIdentifier )
        self.collectionView!.registerClass(CollectionHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: headerReuseIdentifier)
        // delegate:
        if let layout = collectionView?.collectionViewLayout as? ScheduleCollectionLayout {
            layout.delegate = self
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
        return numberOfdays
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
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind("Header", withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as! CollectionHeader
        headerView.dateLabel.text = "OK"
        headerView.backgroundColor = UIColor.lightGrayColor()
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















