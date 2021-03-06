//
//  CollectionScheduleControllerCollectionViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/20/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import DataModel

private let cellReuseIdentifier = "CollectionViewCell"
private let emptyCellReuseIndentifier = "emptyCellReuseIndentifier"
private let multiCellReuseIndentifier = "multiCellReuseIndentifier"
private let headerReuseIdentifier = "CollectionCell"
private let decorationViewReuseIdentifier = "DecorationViewReuseIdentifier"

@objc protocol CollectionScheduleViewControllerDelegate {
    
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func passScheduleToLeftController() -> Void
    var shedule: Shedule! { get }
    @objc optional var zoomScale: CGFloat {get set}
    @objc optional var collectionView: UICollectionView? { get }
    
}

class CollectionScheduleViewController: UICollectionViewController, CollectionScheduleViewControllerDelegate  {
    
    // Displayed schedule object:
    var shedule: Shedule! {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: AppData.scheduleDidReload), object: nil)
            if !shedule.shedule_id.isEmpty {
                DispatchQueue.main.async(execute: {
                    self.button.setTitle("\(self.shedule.shedule_id) ▾", for: UIControlState())
                    self.navigationItem.rightBarButtonItem = self.preferencesBarButton
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.button.setTitle(AppStrings.ChooseSchedule, for: UIControlState())
                    self.navigationItem.rightBarButtonItem = nil
                })
            }
        }
    }
    
    // MARK: - Computed properties:
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Properies:
    
    let shedulesListController = ShedulesListTableViewController()
    let button = TitleViewButton()
    var sideInfoButton: UIBarButtonItem!
    var preferencesBarButton: UIBarButtonItem!
    let scale = CollectionDecorationView()
    let headerScale = CollectionHeaderView()
    var initialScrollDone = false
    var doubleTapGesture = UITapGestureRecognizer()
    var scaleTapGestureRecognizer = UITapGestureRecognizer()
    var weekScheduleControllerDelegate: TableSheduleControllerDelegate!
    var zoomScale: CGFloat = 1.0
    
    //MARK: - Lifecycle:

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = FlatWhite()
        
        // EmptyDataSource:
        collectionView!.emptyDataSetSource = self
        collectionView!.emptyDataSetDelegate = self
        
        //layoutDelegate:
        let layout = collectionViewLayout as! ScheduleCollectionLayout
        //layout.delegate = self
        headerScale.delegate = self
        //scale.delegate = self
        
        //navigationController will be nil on iPad and won't be nil on iPhone:
        if navigationController != nil {
            
            button.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
            button.addTarget(self, action: #selector(CollectionScheduleViewController.showMenu(_:)), for: .touchUpInside)
            navigationItem.titleView = button
            
            sideInfoButton = UIBarButtonItem(image: UIImage(named: "sideInfoButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CollectionScheduleViewController.presentLeftMenuViewController(_:)))
            preferencesBarButton = UIBarButtonItem(image: UIImage(named: "PreferencesButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CollectionScheduleViewController.showPreferencesMenu))
            
            navigationItem.leftBarButtonItem = sideInfoButton
        }
        
        // gesture-recognizers:
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(CollectionScheduleViewController.doubleTapGestureDetected(_:)))
        collectionView?.addGestureRecognizer(doubleTapGesture)
        
        scaleTapGestureRecognizer.addTarget(self, action: #selector(CollectionScheduleViewController.doubleTapGestureDetected(_:)))
        headerScale.addGestureRecognizer(scaleTapGestureRecognizer)
    
        // Register cell classes
        self.collectionView?.register(CollectionScheduleCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView?.register(CollectionScheduleEmptyCell.self, forCellWithReuseIdentifier: emptyCellReuseIndentifier)
        self.collectionView?.register(CollectionScheduleMultiCell.self, forCellWithReuseIdentifier: multiCellReuseIndentifier)
        
        
        // Timescale:
        scale.frame = CGRect(x: 0, y: 0, width: 50, height: collectionView!.contentSize.height)
        scale.configure(collectionView!.bounds.height)
        
        //notification:
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionScheduleViewController.reloadSelf), name: NSNotification.Name(rawValue: AppData.reloadCollectionView), object: nil)
        
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(CollectionScheduleViewController.sample(sender:)))
        collectionView?.addGestureRecognizer(pinchGesture)
        
    }
    
    func sample(sender: UIPinchGestureRecognizer) {
        
        let layout = collectionView?.collectionViewLayout as! ScheduleCollectionLayout
        zoomScale = sender.scale
        print(sender.scale)
        //layout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            configureDateScale()
            let firstEventDay = Date(timeIntervalSince1970: TimeInterval(shedule.startDayTime))
            
            // if semester isn't started yet:
            if firstEventDay > Date() {
                collectionView?.contentOffset = CGPoint(x: 0, y: 0)
                initialScrollDone = true
                return
            }
            let numberOfdays = firstEventDay.differenceInDaysWithDate(Date())
            let offset = numberOfdays < collectionView!.numberOfSections ? numberOfdays : collectionView!.numberOfSections - 1
            collectionView?.contentOffset = CGPoint(x: 126 * offset, y: 0)
            initialScrollDone = true
        }
    }
    
    func configureDateScale() {
        
        headerScale.configure(shedule)
    }
    
    func showMenu(_ sender: UIButton) {
        shedulesListController.hidesBottomBarWhenPushed = true
        if let parent = tabBarController as? MainTabBarController {
            shedulesListController.delegate = parent
        }
        let menuNavigationController = UINavigationController(rootViewController: shedulesListController)
        menuNavigationController.navigationBar.barTintColor = FlatWhite()
        self.present(menuNavigationController, animated: true, completion: nil)
    }
    
    func showPreferencesMenu() {
        let preferencesController = storyboard?.instantiateViewController(withIdentifier: "PreferenceTableViewController") as! PreferenceTableViewController
        let preferenceNavigationController = UINavigationController(rootViewController: preferencesController)
        self.present(preferenceNavigationController, animated: true, completion: nil)
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if shedule == nil && shedule.shedule_id.isEmpty{
            return 0
        }
        return shedule.numberOfDaysInSemester()
    }


     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shedule == nil && shedule.shedule_id.isEmpty {
            return 0
        }
        return shedule.numberOfPairsInDay()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if shedule.eventsCache["\(indexPath.section)\(indexPath.row)"] == nil {
            shedule.performCache()
        }
        let events = shedule.eventsCache["\(indexPath.section)\(indexPath.row)"]!.events
        
        // configure empty cell:
        if events.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellReuseIndentifier, for: indexPath) as! CollectionScheduleEmptyCell
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
        
        // configure multi-event cell:
        if events.count > 1 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multiCellReuseIndentifier, for: indexPath) as! CollectionScheduleMultiCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configure(events, shedule: shedule)
            return cell
            
        // configure single-event cell:
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CollectionScheduleCell
            cell.delegate = self
            cell.indexPath = indexPath
        cell.configure(events, shedule: shedule)
        return cell
        }
    }
    
    func passScheduleToLeftController() {
        let leftSideMenu = self.sideMenuViewController.leftMenuViewController as! LeftMenuVIewController
        leftSideMenu.schedule = shedule
    }
    
    // Sub methods:
    func reloadSelf() {
        collectionView?.reloadData()
    }
}

    // MARK: -  Gestures:

extension CollectionScheduleViewController {
    
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == UIEventSubtype.motionShake{
            performScrollToToday()
            if weekScheduleControllerDelegate != nil {
                weekScheduleControllerDelegate!.performScrollToToday()
            }
        }
    }
    
    func doubleTapGestureDetected(_ sender: UITapGestureRecognizer) {
        performScrollToToday()
    }
    
    func performScrollToToday() {
        let firstEventDay = Date(timeIntervalSince1970: TimeInterval(shedule.startDayTime))
        
        let numberOfdays = firstEventDay.differenceInDaysWithDate(Date())
        
        // check for scrolling possibility.
        if numberOfdays >= collectionView!.numberOfSections || numberOfdays < 0 {
            return
        }
        collectionView!.scrollToItem(at: IndexPath(item: 0, section: numberOfdays), at: UICollectionViewScrollPosition.left, animated: true)
        collectionView?.contentOffset.x -= 50
        collectionView?.contentOffset.y = 0
        
    }
}

    // MARK: - DZNEmptyDataSetSource

extension CollectionScheduleViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "NureTimeTable", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: 1), NSForegroundColorAttributeName: UIColor.lightGray])
    }
}
















