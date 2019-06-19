//
//  AppDelegate.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import ObjectiveDDP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == .keyboard {
            return false
        }
        
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //NetworkManager.shared.startNetworkReachabilityObserver()
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyC1-bAGgQ52sXl4ev2GbXofTDfugryxvY0")
        
        
        Meteor.meteorClient?.ddp = ObjectiveDDP(urlString: "ws://18.224.108.40/websocket", delegate: Meteor.meteorClient!)
        Meteor.meteorClient?.ddp.connectWebSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reportConnection), name: NSNotification.Name.MeteorClientDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reportDisconnection), name: NSNotification.Name.MeteorClientDidDisconnect, object: nil)
        return true
    }

    @objc func reportConnection() {
        print("================> connected to server!")
    }
    
    @objc func reportDisconnection() {
        print("================> disconnected from server!")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

