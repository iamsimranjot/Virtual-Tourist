//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 09/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillResignActive(_ application: UIApplication) {
        
        sharedDataManager.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        sharedDataManager.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        sharedDataManager.save()
    }
}

