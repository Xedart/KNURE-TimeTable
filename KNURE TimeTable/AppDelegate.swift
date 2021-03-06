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
    var eventsManager: CalendarManager!
    var deviceAPNToken: String?
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow()
        performCleanUp()
        registerPushNotifications()
        presentRootViewController()
        return true
    }
    
    func presentRootViewController() {
        //TODO: uncomment after finishing guideviewController:
        /*
        if isInitiaLunchDone() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController") as! SideMenuViewController
        } else {
            window?.rootViewController = AppGuideViewController()
        } */
        
        //window?.rootViewController = AppGuideViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController") as! SideMenuViewController
        window?.makeKeyAndVisible()
    }
    
    //MARK: - Utility methods:
    
    func performCleanUp() {
        
        if (defaults.object(forKey: AppData.cleanUpMark) as? Bool) == nil {
            if (defaults.object(forKey: AppData.defaultScheduleKey) as? String) != nil {
                
                // perform the cleanUp:
                defaults.set(nil, forKey: AppData.defaultScheduleKey)
                defaults.set(nil, forKey: AppData.savedGroupsShedulesKey)
                defaults.set(nil, forKey: AppData.savedTeachersShedulesKey)
                defaults.set(nil, forKey: AppData.savedAuditoriesShedulesKey)
                
                let alert = UIAlertController(title: AppStrings.Information, message: AppStrings.cleanUpInfo, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AppStrings.Done, style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                
            }
            //set the clean up mark to indicate that cleaning up was done:
            defaults.set(true, forKey: AppData.cleanUpMark)
        }
    }
    
    func isInitiaLunchDone() -> Bool {
        
        return defaults.bool(forKey: AppData.initialLunchKey)
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
        eventsManager = CalendarManager()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

