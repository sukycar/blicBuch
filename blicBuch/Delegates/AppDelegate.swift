//
//  AppDelegate.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 11/16/19.
//  Copyright © 2019 sukydeveloper. All rights reserved.
//

import UIKit
import CoreData
import SideMenu
import Kingfisher
import Firebase
import FirebaseCore
import SwiftyStoreKit
import StoreKit
import SwiftKeychainWrapper


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var sideMenuController: SideMenuViewController?
    var userId: String?
    let swiftyHelper = SwiftyStoreKitHelper()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        ImageCache.default.diskStorage.config.expiration = StorageExpiration.days(30)
        ImageCache.default.memoryStorage.config.countLimit = 1000
        KingfisherManager.shared.cache = ImageCache.default
        KingfisherManager.shared.downloader.trustedHosts = Set([Environment.configuration(.allowedKingfisherUrl)])
        FirebaseApp.configure()
        
        // Check app purchase state and finish transactions
        swiftyHelper.completeTransactions()
        return true
    }
    
    func getSideMenu() -> SideMenuViewController {
        sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuViewController
        return sideMenuController!
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setWindow(vc:UIViewController, animated:Bool){
        vc.view.layoutIfNeeded()
        if animated{
            for view in UIApplication.shared.connectedScenes {
                if let window = (view.delegate as? SceneDelegate)?.window {
                    UIView.transition(with: window, duration: 0.1, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {[weak window] in
                        window?.rootViewController =  vc
                    }) { (finished) in
                        window.makeKeyAndVisible()
                    }
                }
            }
        }else{
            for view in UIApplication.shared.connectedScenes {
                if let window = (view.delegate as? SceneDelegate)?.window {
                    window.rootViewController =  vc
                    window.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "blicBuch")
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
    func saveContext () {
        let context = persistentContainer.viewContext
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
    
}
