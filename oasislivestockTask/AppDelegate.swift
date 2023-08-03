//
//  AppDelegate.swift
//  oasislivestockTask
//
//  Created by An0nymous on 03/08/2023.
//

import UIKit
import CoreMotion
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let activityManager = CMMotionActivityManager()
        let pedometer = CMPedometer()

        if CMMotionActivityManager.isActivityAvailable() {
            activityManager.startActivityUpdates(to: .main) { (activity: CMMotionActivity?) in
                // Handle activity data if needed
            }
        }

        if CMPedometer.isStepCountingAvailable() {
            pedometer.queryPedometerData(from: Date(), to: Date()) { (data: CMPedometerData?, error: Error?) in
                // Handle pedometer data if needed
            }
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if let error = error {
                    print("Error requesting notification permission: \(error.localizedDescription)")
                }
        }
        
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

