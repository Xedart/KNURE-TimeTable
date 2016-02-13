//
//  MainTabBarController.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/11/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Data-source
    
    var shedule: Shedule!

    override func viewDidLoad() {
        super.viewDidLoad()
        shedule = Shedule()
        let nav = viewControllers![0] as! UINavigationController
        let contr = nav.viewControllers[0] as! TableSheduleController
        contr.shedule = shedule

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
