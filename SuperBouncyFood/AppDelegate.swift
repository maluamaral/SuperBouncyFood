//
//  AppDelegate.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 27/01/22.
//

import UIKit
import Firebase
import AdSupport
import AppTrackingTransparency
import FBSDKCoreKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkSoundPreference()
        // Override point for customization after application launch.
        application.isStatusBarHidden = true
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Ask tracking
        self.requestDataPermission()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    private func checkSoundPreference() {
        if UserDefaults.standard.object(forKey: Constants.PLAY_MUSIC_KEY) == nil {
            UserDefaults.standard.set(true, forKey: Constants.PLAY_MUSIC_KEY)
        }
        
        if UserDefaults.standard.object(forKey: Constants.PLAY_SOUND_EFFECTS_KEY) == nil {
            UserDefaults.standard.set(true, forKey: Constants.PLAY_SOUND_EFFECTS_KEY)
        }
    }
    
    func requestDataPermission() {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                self.setTracking(true)
            } else if ATTrackingManager.trackingAuthorizationStatus == .denied || ATTrackingManager.trackingAuthorizationStatus == .restricted {
                self.setTracking(false)
            } else if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        if status == .authorized {
                            self.setTracking(true)
                        } else {
                            self.setTracking(false)
                        }
                    }
                })
            }
        }
    }
    
    func setTracking(_ tracking: Bool) {
        Analytics.setUserProperty("\(tracking)".lowercased(),
                                  forName: AnalyticsUserPropertyAllowAdPersonalizationSignals)
        Analytics.setAnalyticsCollectionEnabled(tracking)
        // Facebook ads
        Settings.shared.isAdvertiserTrackingEnabled = tracking
        Settings.shared.isAutoLogAppEventsEnabled = tracking
        Settings.shared.isAdvertiserIDCollectionEnabled = tracking
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}

