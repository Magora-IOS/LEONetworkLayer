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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(LeoTestClass.value)
        print(LeoTestClass2.value)
        
        return true
    }

}

