//
//  MainSplitViewController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
// displaying:
        maximumPrimaryColumnWidth = CGFloat.max
        preferredPrimaryColumnWidthFraction = 0.4
        preferredDisplayMode = .AllVisible
    }

    
}
