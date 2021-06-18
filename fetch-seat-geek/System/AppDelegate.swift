//
//  AppDelegate.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, WindowManaging {
    private lazy var _appManager = ApplicationManager(windowManager: self)
    var appManager: ApplicationManager {
        return _appManager
    }
    
    var window : UIWindow?
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
        -> Bool {
            if #available(iOS 13, *) {
                // Any initialization before SceneDelegate
            } else {
                self.window = UIWindow()
                appManager.presentRequiredPage()
            }
            return true
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
