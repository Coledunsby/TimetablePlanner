//
//  AppDelegate.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-11-17.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Register Parse Subclasses
        TPUser.registerSubclass()
        TPCourse.registerSubclass()
        TPSession.registerSubclass()
        TPTimeslot.registerSubclass()
        TPTimetable.registerSubclass()
        
        // Parse
        ParseCrashReporting.enable()
        Parse.setApplicationId("SRQ1XUWQSIMREQClucMJXTzv0fR4ustN5ktA1ZHW", clientKey: "cUmWEteHyHghrYMXBNRpD6ZvofFGTHuaDVU7JuXy")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Status Bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Navigation Bar
        UINavigationBar.appearance().tintColor = FlatGreen()
        UINavigationBar.appearance().barTintColor = FlatBlack()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: FlatGreen(), NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 16)!], forState: .Normal)
        
        // Tab Bar
        UITabBar.appearance().tintColor = FlatGreen()
        UITabBar.appearance().barTintColor = FlatBlack()
        UITabBar.appearance().translucent = false
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}
