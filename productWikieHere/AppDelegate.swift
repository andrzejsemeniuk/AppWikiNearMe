//
//  AppDelegate.swift
//  productWikieHere
//
//  Created by andrzej semeniuk on 3/21/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    static var controllerOfList:    ControllerOfList!           = nil
    
    static var managerOfLocation:   CLLocationManager!          = nil
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // set style of page controllers
        //        UIPageControl *pageControl = [UIPageControl appearance];
        //        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        //        pageControl.backgroundColor = [UIColor blueColor];
        
        
        AppDelegate.managerOfLocation                   = CLLocationManager()
        AppDelegate.managerOfLocation.delegate          = self
        AppDelegate.managerOfLocation.desiredAccuracy   = 2.0
        //        AppDelegate.managerOfLocation.requestAlwaysAuthorization()// use this authorization method for location streaming
        AppDelegate.managerOfLocation.requestWhenInUseAuthorization()       // use this authorization method for location polling
        
        
        
        //        Data.Manager.reset()
        //        Data.Manager.settingsUse("Default")
        Data.Manager.resetIfEmpty()
        
        
        
        let WINDOW                          = window!
        
        WINDOW.screen                       = UIScreen.mainScreen()
        WINDOW.bounds                       = WINDOW.screen.bounds
        WINDOW.windowLevel                  = UIWindowLevelNormal
        
        
        AppDelegate.controllerOfList        = ControllerOfList()
        
        let NAVIGATOR                       = UINavigationController(rootViewController:AppDelegate.controllerOfList)
        
        NAVIGATOR.navigationBar.translucent         = true
        NAVIGATOR.navigationBar.backgroundColor     = UIColor.clearColor()
        
        
        WINDOW.rootViewController           = NAVIGATOR
        
        WINDOW.makeKeyAndVisible()
        
        
        AppDelegate.updateLocation()
        
        
        return true
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    // MARK: - Generic Error Alert
    
    
    static func showAlertWithError(title title:String = "Error", message:String)
    {
        let alert = UIAlertController(title:title, message:message, preferredStyle:.Alert)
        
        let actionOK = UIAlertAction(title:"OK", style:.Cancel, handler: {
            action in
        })
        
        alert.addAction(actionOK)
        
        AppDelegate.rootViewController.presentViewController(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    
    
    
    // MARK: - Core Location Delegate methdds
    
    static var authorizationStatusUpdated:(()->())?
    static var locationsUpdated:((ok:Bool)->())?
    static var locations:[CLLocation]                   = []
    
    
    static func updateLocation()
    {
        let disallowed = [
            CLAuthorizationStatus.Restricted,
            CLAuthorizationStatus.Denied
        ]
        
        let ok = AND(NOT(disallowed.contains(CLLocationManager.authorizationStatus())),CLLocationManager.locationServicesEnabled())
        
        if ok {
            AppDelegate.managerOfLocation.requestLocation()
        }
        else {
            AppDelegate.locationsUpdated?(ok:false)
            AppDelegate.showAlertWithError(title:"Unauthorized", message:"Use of location services is not authorized.")
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        print("locationManager: didUpdateLocations: \(locations)")
        
        AppDelegate.locations = locations
        
        AppDelegate.locationsUpdated?(ok:true)
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError)
    {
        print("locationManager: didFailWithError: \(error)")
        
        AppDelegate.locationsUpdated?(ok:false)
        
        AppDelegate.showAlertWithError(title:"Location Manager Error", message:"Failed with error: "+error.description)
    }
    
    func locationManager(manager: CLLocationManager,
                         didFinishDeferredUpdatesWithError error: NSError?)
    {
        print("locationManager: didFinishDeferredUpdatesWithError: \(error)")
        
        AppDelegate.locationsUpdated?(ok:false)
        
        if let error = error {
            AppDelegate.showAlertWithError(title:"Location Manager Error", message:"Finished deferred updates with error: "+error.description)
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager,
                         didVisit visit: CLVisit)
    {
        print("locationManager: didVisit: \(visit)")
    }
    
    
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus)
        
    {
        print("locationManager: didChangeAuthorizationStatus: \(status)")
        
        AppDelegate.authorizationStatusUpdated?()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tinygamefactory.productWikieHere" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("productWikieHere", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

