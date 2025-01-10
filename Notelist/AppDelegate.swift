//
//  AppDelegate.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        resetRealm()
        let config = Realm.Configuration(schemaVersion: 1) // Đặt schema version về 1 (mới)
        Realm.Configuration.defaultConfiguration = config
        
        // Initialize Realm
        _ = try! Realm() 
                // Khởi tạo window
               window = UIWindow(frame: UIScreen.main.bounds)
               
               // Thiết lập ViewController đầu tiên
               let initialViewController = ViewController() // Thay thế ViewController() bằng ViewController bạn muốn
               window?.rootViewController = initialViewController
               window?.makeKeyAndVisible()
                return true
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


}

import RealmSwift

func resetRealm() {
    let realmURL = Realm.Configuration.defaultConfiguration.fileURL
    let realmURLs = [
        realmURL,
        realmURL?.appendingPathExtension("lock"),
        realmURL?.appendingPathExtension("note"),
        realmURL?.appendingPathExtension("management")
    ]
    
    for url in realmURLs {
        if let url = url {
            do {
                try FileManager.default.removeItem(at: url)
                print("Deleted Realm file at: \(url)")
            } catch {
                print("Failed to delete Realm file: \(error)")
            }
        }
    }
}
