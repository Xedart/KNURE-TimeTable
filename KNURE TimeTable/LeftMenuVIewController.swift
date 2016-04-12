//
//  LeftMenuVIewController.swift//
//  KNURE TimeTable
//
//  Created by Shkil Artur on 4/9/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class LeftMenuVIewController: UIViewController {
    
    var schedule: Shedule!
    var infoTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        var tableViewHeight = CGFloat()
        
        //defining tableViewHeight
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            tableViewHeight = 54.0
        } else if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            tableViewHeight = 74.0
        }
        
        // tableViewSetup:
        infoTableView = UITableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - tableViewHeight * 5) / 2.0, width: self.view.frame.size.width, height: tableViewHeight * 5), style: UITableViewStyle.Plain)
        infoTableView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleTopMargin, .FlexibleWidth]
        infoTableView.delegate = self;
        infoTableView.dataSource = self;
        infoTableView.opaque = false;
        infoTableView.backgroundColor = UIColor.clearColor();
        infoTableView.backgroundView = nil;
        infoTableView.separatorStyle = .None;
        infoTableView.bounces = false;
        infoTableView.scrollsToTop = false;
        
        self.view.addSubview(infoTableView)
        
    }
}


extension LeftMenuVIewController: UITableViewDelegate {
    
}

extension LeftMenuVIewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = "sdlkjfklsdf"
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}












