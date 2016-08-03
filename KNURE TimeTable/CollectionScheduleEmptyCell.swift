//
//  CollectionScheduleEmptyCell.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/28/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//.

import UIKit

class CollectionScheduleEmptyCell: UICollectionViewCell {
    
    var gestureRecognizer = UILongPressGestureRecognizer()
    var delegate: CollectionScheduleViewControllerDelegate!
    var indexPath: IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gestureRecognizer.addTarget(self, action: #selector(CollectionScheduleEmptyCell.presentCusomEventMenu(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func configure(_ events: [Event], shedule: Shedule) {
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods:
    
    // presenation:
    func presentCusomEventMenu(_ sender: UILongPressGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customEventViewController = storyboard.instantiateViewController(withIdentifier: "CustomEventNavigationViewController") as! UINavigationController
        customEventViewController.modalPresentationStyle = .formSheet
        customEventViewController.modalTransitionStyle = .crossDissolve
        delegate.presentViewController(customEventViewController, animated: true, completion: nil)
        let destionationController = customEventViewController.viewControllers[0] as! CustomEventTableViewController
        destionationController.delegate = self.delegate
        destionationController.indexPath = self.indexPath

    }
}






