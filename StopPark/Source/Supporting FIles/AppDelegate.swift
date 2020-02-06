//
//  AppDelegate.swift
//  StopPark
//
//  Created by Arman Turalin on 12/10/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
import Firebase
//import


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow()
        
        if AuthorizationManager.authorized {
            let router = HomeRouter()
            let vc = HomeVC(router: router)
            let nav = CustomNavigationController(rootViewController: vc)
            router.baseViewController = vc
            window?.rootViewController = nav
        } else {
            let vc = RegistrationVC()
            let nav = CustomNavigationController(rootViewController: vc)
            vc.title = "Регистрация"
            nav.navigationBar.prefersLargeTitles = true
            window?.rootViewController = nav
        }
        
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        Fabric.sharedSDK().debug = true
        return true
    }
}

