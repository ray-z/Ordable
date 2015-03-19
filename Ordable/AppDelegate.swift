//
//  AppDelegate.swift
//  Ordable
//
//  Created by Ray on 2/17/15.
//  Copyright (c) 2015 LeiZeng. All rights reserved.
//

import UIKit

protocol MainDelegate
{
    func refreshAmount(oldAmount:Double, date:String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var orderVCDelegate: MainDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
//        println(getDay())
        // Check if is the first launch
        if(!NSUserDefaults.standardUserDefaults().boolForKey(KeyFirstLaunch))
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: KeyFirstLaunch)
            NSUserDefaults.standardUserDefaults().setDouble(0.00, forKey: KeyTotalAmount)
            NSUserDefaults.standardUserDefaults().setObject(getDate(), forKey: KeyDate)
            
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        checkDate()
        return true
    }
    
    func getDate() -> String
    {
        let date = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.stringFromDate(date)
    }

    func getDay() -> Int
    {
        let date = NSDate()
//        let formatter  = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.stringFromDate(date)
        
        let calendar = NSCalendar.currentCalendar()
        let day = calendar.component(.DayCalendarUnit, fromDate: date)
    
        
        return day
    }
    
    func checkDate()
    {
        var oldDate = NSUserDefaults.standardUserDefaults().valueForKey(KeyDate) as String
        var oldAmount = NSUserDefaults.standardUserDefaults().valueForKey(KeyTotalAmount) as Double
        var newDate = getDate()
        
        
        if (oldDate != newDate)   // save total amount, reset to 0
        {
            NSUserDefaults.standardUserDefaults().setDouble(0.00, forKey: KeyTotalAmount)
            NSUserDefaults.standardUserDefaults().setObject(newDate, forKey: KeyDate)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            orderVCDelegate?.refreshAmount(oldAmount, date:oldDate)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkDate()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

