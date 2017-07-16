//
//  AppDelegate.swift
//  todoapp
//
//  Created by Amadeu Cavalcante Filho on 7/15/17.
//  Copyright © 2017 Amadeu Cavalcante Filho. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            syncConfiguration: nil,
            objectTypes: [TodoListList.self, TodoList.self, TodoItem.self]
        )
        
        let realm = try! Realm()
        
        if realm.isEmpty {
            try! realm.write {
                let list = TodoList()
                let todoItem = TodoItem()
                list.items.append(todoItem)
                list.id = Constants.defaultListID
                list.title = Constants.defaultListName
                list.createdAt = Date()
                let listLists = TodoListList()
                listLists.items.append(list)
                realm.add(listLists)
            }
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

