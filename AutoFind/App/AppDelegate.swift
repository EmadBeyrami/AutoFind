//
//  AppDelegate.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/16/21.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // I Used Coordinator pattern for flow of app.
        setupCoordinator()
        
        return true
    }

    fileprivate func setupCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()

        appCoordinator = AppCoordinator(navigationController: navController, window: window)
        appCoordinator.start()
    }
    
}
