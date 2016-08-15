//
//  SideMenuRootViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/8/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation
import RESideMenu
import DataModel

class SideMenuViewController: RESideMenu, RESideMenuDelegate {
    
    var shouldRotate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()       
    }
    
    override func awakeFromNib() {
        
        panGestureEnabled = false
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            contentViewInPortraitOffsetCenterX = 70
            contentViewInLandscapeOffsetCenterX = 170
            contentViewScaleValue = 0.8
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            contentViewInPortraitOffsetCenterX = 0
            contentViewInLandscapeOffsetCenterX = 50
            contentViewScaleValue = 0.8
        }
        
        //setStatusBarStyle(UIStatusBarStyle.lightContent)
        
        backgroundImage = UIImage(named: "BluredBackground")
        self.delegate = self
        
        var contentViewControllerID = String()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            contentViewControllerID = "IPhoneRootViewController"
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            contentViewControllerID = "IPadRootViewController"
        }
        
        self.contentViewController = (self.storyboard?.instantiateViewController(withIdentifier: contentViewControllerID))! as UIViewController
        
        self.leftMenuViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController"))! as UIViewController
    }
    
    // MARK: RESide Delegate Methods
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        let leftController = self.leftMenuViewController as! LeftMenuVIewController
        leftController.infoTableView.reloadData()
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
         NotificationCenter.default.post(name: NSNotification.Name(AppData.reloadTableView), object: nil)
        NotificationCenter.default.post(name: Notification.Name(AppData.reloadCollectionView), object: nil)
    }
}
