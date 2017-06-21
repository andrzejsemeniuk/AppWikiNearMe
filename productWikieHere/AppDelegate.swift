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
    
    static var rootViewController:  UIViewController!           = nil
    
    static var controllerOfList:    ControllerOfList!           = nil
    
    static var managerOfLocation:   CLLocationManager!          = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        
        WINDOW.screen                       = UIScreen.main
        WINDOW.bounds                       = WINDOW.screen.bounds
        WINDOW.windowLevel                  = UIWindowLevelNormal
        
        
        AppDelegate.controllerOfList        = ControllerOfList()
        
        let NAVIGATOR                       = UINavigationController(rootViewController:AppDelegate.controllerOfList)
        
        NAVIGATOR.navigationBar.isTranslucent         = true
        NAVIGATOR.navigationBar.backgroundColor     = UIColor.clear
        
        
        AppDelegate.rootViewController      = NAVIGATOR
        WINDOW.rootViewController           = NAVIGATOR
        
        WINDOW.makeKeyAndVisible()
        
        
        AppDelegate.updateLocation()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        AppDelegate.saveContext()
    }
    
    
    // MARK: - Generic Error Alert
    
    
    static func showAlertWithError(_ title:String = "Error", message:String)
    {
        let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        
        let actionOK = UIAlertAction(title:"OK", style:.cancel, handler: {
            action in
        })
        
        alert.addAction(actionOK)
        
        AppDelegate.rootViewController.present(alert, animated:true, completion: {
            print("completed showing add alert")
        })
    }
    
    
    
    // MARK: - Core Location Delegate methdds
    
    static var authorizationStatusUpdated:(()->())?
    static var locationsUpdated:((_ ok:Bool)->())?
    static var locations:[CLLocation]                   = []
    
    
    static func updateLocation()
    {
        let disallowed = [
            CLAuthorizationStatus.restricted,
            CLAuthorizationStatus.denied
        ]
        
        let ok = !disallowed.contains(CLLocationManager.authorizationStatus()) && CLLocationManager.locationServicesEnabled()
        
        if ok {
            AppDelegate.managerOfLocation.requestLocation()
        }
        else {
            AppDelegate.locationsUpdated?(false)
            AppDelegate.showAlertWithError("Unauthorized", message:"Use of location services is not authorized.")
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        print("locationManager: didUpdateLocations: \(locations)")
        
        AppDelegate.locations = locations
        
        AppDelegate.locationsUpdated?(true)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print("locationManager: didFailWithError: \(error)")
        
        AppDelegate.locationsUpdated?(false)
        
        AppDelegate.showAlertWithError("Location Manager Error", message:"Failed with error: "+error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFinishDeferredUpdatesWithError error: Error?)
    {
        print("locationManager: didFinishDeferredUpdatesWithError: \(String(describing: error))")
        
        AppDelegate.locationsUpdated?(false)
        
        if let error = error {
            AppDelegate.showAlertWithError("Location Manager Error", message:"Finished deferred updates with error: "+error.localizedDescription)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         didVisit visit: CLVisit)
    {
        print("locationManager: didVisit: \(visit)")
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
        
    {
        print("locationManager: didChangeAuthorizationStatus: \(status)")
        
        AppDelegate.authorizationStatusUpdated?()
    }
    
    
    // MARK: - Core Data stack
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return AppDelegate.persistentContainer.persistentStoreCoordinator
    }()
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "productWikieHere")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = AppDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Older Stuff
    
    static var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tinygamefactory.productWikieHere" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return (urls[urls.count-1] as NSURL) as URL
    }()
    
    static var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "productWikieHere", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    static var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = AppDelegate.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    
}

