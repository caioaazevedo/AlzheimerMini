//
//  AppDelegate.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 16/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CoreData
import UIKit
import Foundation
import UserNotifications
import CloudKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let sb = UIStoryboard(name: "Onboard", bundle: nil)
        var inicialViewController = sb.instantiateViewController(withIdentifier: "Onbording")

        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: "onbordingComplete") {
            let sb = UIStoryboard(name: "LauchScreenAnimation", bundle: nil)
            inicialViewController = sb.instantiateViewController(withIdentifier: "launchScreen")
        }

        window?.rootViewController = inicialViewController
        window?.makeKeyAndVisible()
        
        //Cloud Push-Up notifications ⚡️
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (result, error) in
            
            if let error = error{
                print("Erro ao coletar a permissão: ",error)
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            
        }
        //Cloud Push-Up notifications ⚡️
        
//                Cloud.getPeople()
        
        CoreDataRebased.shared.getImages()
        
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        //Cloud Push-Up notifications ⚡️
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = 0
            let operation = CKModifyBadgeOperation(badgeValue: 0)
            operation.modifyBadgeCompletionBlock = { (error) in
                if let error = error{
                    print("ERROR",error)
                    return
                }
            }
            cloudContainer.add(operation)
        }
        //Cloud Push-Up notifications ⚡️
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AlzheimerProject")
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
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("url \(url)")
        print("url host :\(url.host!)")
        

        Cloud.checkUsuario(searchUsuario: UserLoaded().recuperarId()) { (result) in
            if result {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "inicialStoryboard")
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else {
                let loginStoryboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let initialViewController : GuestViewController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! GuestViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                initialViewController.insertCode(code: "\(url.host!)")
            }
        }
        
        return true
    }
    
    
    

}

