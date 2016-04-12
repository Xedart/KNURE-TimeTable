//
//  SideMenuRootViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/8/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation
import RESideMenu

class SideMenuViewController: RESideMenu, RESideMenuDelegate {
    
    var shouldRotate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()       
    }
    
    override func awakeFromNib() {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            contentViewInPortraitOffsetCenterX = 0
            contentViewInLandscapeOffsetCenterX = 0
            contentViewScaleValue = 0.7
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            contentViewInPortraitOffsetCenterX = -30
            contentViewInLandscapeOffsetCenterX = -30
            contentViewScaleValue = 0.8
        }
        
        backgroundImage = UIImage(named: "BluredBackground")
        self.delegate = self
        
        var contentViewControllerID = String()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            contentViewControllerID = "IPhoneRootViewController"
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            contentViewControllerID = "IPadRootViewController"
        }
        
        self.contentViewController = (self.storyboard?.instantiateViewControllerWithIdentifier(contentViewControllerID))! as UIViewController
        
        self.leftMenuViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("LeftMenuViewController"))! as UIViewController
    }
    
    // MARK: RESide Delegate Methods
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        let leftController = self.leftMenuViewController as! LeftMenuVIewController
        leftController.infoTableView.reloadData()
        shouldRotate = false
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        shouldRotate = true
    }
    
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        // TODO: rotate interfce if device was rotated with menu opened.
    }
}
