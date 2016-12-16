//
//  AppDelegate.swift
//  Beacon
//
//  Created by Denis Nascimento on 15/12/16.
//  Copyright © 2016 Denis Nascimento. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications;

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    

    var window: UIWindow?
    
    var lastProximity: CLProximity?
    
    let beaconIdentifier: String = "M4U"
    
    var locationManager: CLLocationManager!
    var count: Int = 0
    
    
    let uuidString = "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert , .sound]) { (greanted, error) in
                if greanted {
                    UIApplication.shared.registerForRemoteNotifications();
                }
            }
        } else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        startScanning()

        return true
    }

    func showPromoVC() -> Void {
        
    let viewController:PromoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "promoVC") as!  PromoViewController
        self.window?.rootViewController?.present(viewController, animated: true, completion: {
            
        })
        
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let log = String(format: "%@", deviceToken as CVarArg)
        print("log\(log)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("didReceiveLocalNotification")
        showPromoVC()
    }
    
    
    func sendLocalNotificationWithMessage(message: String!) {
        
        let content = UNMutableNotificationContent()
        
        content.categoryIdentifier = "awesomeNotification"
        content.title = "Cielo Lio"
        content.body = message
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "error")
        }
        print("should have been added")
        
    }
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning() {
        
        let beaconUUID:NSUUID = NSUUID(uuidString: uuidString.uppercased())!
        let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID as UUID,identifier: beaconIdentifier)
        
        beaconRegion.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        print("startScanning")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion")
        sendLocalNotificationWithMessage(message: "didEnterRegion")
    }
    
    func locationManager(_ manager: CLLocationManager,didExitRegion region: CLRegion) {
        print("didExitRegion");
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            _ = beacons[0]
             print("beacon:\(beacons[0].proximityUUID.uuidString)")
            
        }
    }

    
}

