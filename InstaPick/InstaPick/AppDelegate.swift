//
//  AppDelegate.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let rootController =  window?.rootViewController as? ImageListViewController {
            
        }
        
        return true
    }
}

