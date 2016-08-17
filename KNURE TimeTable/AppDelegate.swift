//
//  AppDelegate.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/4/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit
import QuartzCore
import DataModel
import SVProgressHUD

let didEnterToActive = "didEnterToActive"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Clean up workflow in order to prevent crash when old app is updated to new version.
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: AppData.cleanUpMark) as? Bool) == nil {
            if (defaults.object(forKey: AppData.defaultScheduleKey) as? String) != nil {
                
                // perform the cleanUp:
                defaults.set(nil, forKey: AppData.defaultScheduleKey)
                defaults.set(nil, forKey: AppData.savedGroupsShedulesKey)
                defaults.set(nil, forKey: AppData.savedTeachersShedulesKey)
                defaults.set(nil, forKey: AppData.savedAuditoriesShedulesKey)
            }
            
            //set the clean up mark to indicate that clening up was done:
            defaults.set(true, forKey: AppData.cleanUpMark)
            
            let alert = UIAlertController(title: AppStrings.Information, message: AppStrings.cleanUpInfo, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppStrings.Done, style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state..
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game..
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: didEnterToActive), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

