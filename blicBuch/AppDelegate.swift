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
import RxSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private static var tosterLoader = Array<String?>()
    private static var presentingToaster = false
    private var sideMenuController:SideMenuViewController?
    fileprivate var disposeBag = DisposeBag()
    var bgTask : UIBackgroundTaskIdentifier!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        FirebaseApp.configure()
        
        ImageCache.default.diskStorage.config.expiration = StorageExpiration.days(30)
        ImageCache.default.memoryStorage.config.countLimit = 1000
        KingfisherManager.shared.cache = ImageCache.default
        KingfisherManager.shared.downloader.trustedHosts = Set([Environment.configuration(.allowedKingfisherUrl)])
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    
    func applicationWillTerminate(_ application: UIApplication) {
//        var books = [Book]()
//        var cartBooks = [CartBook]()
//        let context = DataManager.shared.context
//        _ = blicBuchUserDefaults.set(.logedIn, value: false)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logedOut"), object: nil)
//        let lockedBooks = blicBuchUserDefaults.get(.cartItems) as? [String]
//        let request = Book.fetchRequest() as NSFetchRequest
//        let cartRequest = CartBook.fetchRequest() as NSFetchRequest
//        if let lockedBooks = lockedBooks {
//            request.predicate = NSPredicate(format: "ANY id in %@", lockedBooks)
//            cartRequest.predicate = NSPredicate(format: "ANY id in %@", lockedBooks)
//        }
//        do {
//            books = try context?.fetch(request) ?? [Book]()
//            try! context?.save()
//        } catch {
//            print("Not saved")
//        }
//        do {
//            cartBooks = try context?.fetch(cartRequest) ?? [CartBook]()
//            try! context?.save()
//        } catch {
//            print("Cart not erased")
//        }
//
//        books.forEach({
//            $0.locked = LockStatus.unlocked.rawValue
//            let vipStatus = $0.vip
//            let bookId = $0.id
//                if vipStatus == true {
//                        let numberOfAvailableVipBooks = blicBuchUserDefaults.get(.numberOfVipBooks) as? Int ?? 0
//                        let numberOfAvailableRegularBooks = blicBuchUserDefaults.get(.numberOfRegularBooks) as? Int ?? 0
//                        let userId = blicBuchUserDefaults.get(.id) as? Int32 ?? 0
//                        
//                        UsersService.changeAvailableBooksNumber(vip: vipStatus, removeBooks: false, userId: userId, numberOfVipBooks: numberOfAvailableVipBooks , numberOfRegularBooks: numberOfAvailableRegularBooks ).subscribe { (changed) in
//                            //
//                        } onError: { (error) in
//                            print(error)
//                        } onCompleted: {
//                            //
//                        }.disposed(by: DisposeBag())
//                    
//                } else {
//                        let numberOfAvailableRegularBooks = blicBuchUserDefaults.get(.numberOfRegularBooks) as? Int ?? 0
//                        let numberOfAvailableVipBooks = blicBuchUserDefaults.get(.numberOfVipBooks) as? Int ?? 0
//                        let userId = blicBuchUserDefaults.get(.id) as? Int32 ?? 0
//                        
//                        UsersService.changeAvailableBooksNumber(vip: vipStatus, removeBooks: false, userId: userId, numberOfVipBooks: numberOfAvailableVipBooks , numberOfRegularBooks: numberOfAvailableRegularBooks ).subscribe { (changed) in
//                            //
//                        } onError: { (error) in
//                            print(error)
//                        } onCompleted: {
//                            //
//                        }.disposed(by: DisposeBag())
//                }
//                
//        })
//        cartBooks.forEach({
//            let id = $0.id
//            BooksService.lockBook(bookId: id, lockStatus: .unlocked).subscribe { (unlocked) in
//             //
//            } onError: { (error) in
//                print(error.localizedDescription)
//            } onCompleted: {
//                print("COMPLETED")
//            }.disposed(by: DisposeBag())
//
//            $0.inCart = false
//            try! context?.save()
//        })
//        _ = blicBuchUserDefaults.set(.cartItems, value: [""])
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
    
    //MARK: - general logout function
    /*func logout(withError:Error?){
     self.finalLogout(withError: withError)
     }
     private func finalLogout(withError:Error?){
     UserDefaults.reset()
     setWindow(vc: LoginController.getController(), animated:true)
     //        if let withError = withError{
     //            AppDelegate.error(error:withError)
     //        }
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
     let delegate = UIApplication.shared.delegate as! AppDelegate
     let context = delegate.persistentContainer.viewContext
     
     for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1 {
     let entity = delegate.persistentContainer.managedObjectModel.entities[i]
     
     do {
     let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
     let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
     try context.execute(deleterequest)
     try context.save()
     
     } catch let error as NSError {
     print("Error: \(error.localizedDescription)")
     abort()
     }
     }
     }
     }*/
    
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

