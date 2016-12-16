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
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        startScanning()
        

        return true
    }

    func showPromoVC() -> Void {

        let viewController:PromoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "promoVC") as!  PromoViewController
        self.window?.rootViewController?.present(viewController, animated: true, completion: {})
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        
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
            print( "error")
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



