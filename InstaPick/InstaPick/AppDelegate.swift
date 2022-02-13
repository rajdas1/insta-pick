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
        
        if let rootController =  window?.rootViewController as? ImageListViewController {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            rootController.viewModel = ImageListViewModel(
                NetworkManager(),
                imageRepository: ImageRepository(),
                dateFormatter: dateFormatter,
                isLoading: false
            )
        }
        return true
    }
}

