//
//  AppDelegate.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 19/07/2019.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit
import LEONetworkLayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let context = AppContext()
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.startRouter()
        return true
    }

    private func startRouter() {
        let screenBounds = UIScreen.main.bounds
        window = UIWindow(frame: screenBounds)
        window?.makeKeyAndVisible()

        appCoordinator = AppCoordinator(window: window!, context: context)
        appCoordinator.start()
    }
}
