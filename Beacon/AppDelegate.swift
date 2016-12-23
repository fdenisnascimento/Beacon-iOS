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
import CoreBluetooth

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate,CBCentralManagerDelegate {
    
    

    var window: UIWindow?
    
    var lastProximity: CLProximity?
    let beaconIdentifier: String = "M4U"
    var locationManager: CLLocationManager!
    let uuidString = "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6"
    
    let center = UNUserNotificationCenter.current()
    let notificationDelegate = FDNLNotificationDelegate()
    

    var centralManager = CBCentralManager()
    

    class func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        center.delegate = notificationDelegate
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        startMonitor()
        

        return true
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func startMonitor() -> Void {
        
    
            centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        
            let beaconUUID:NSUUID = NSUUID(uuidString: uuidString.uppercased())!
            let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID as UUID,identifier: beaconIdentifier)
        
            beaconRegion.notifyEntryStateOnDisplay = true
            locationManager.delegate = self
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            locationManager.startUpdatingLocation()
        
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
        
        // Swift
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        // Swift
        let identifier = "FDNLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
    }


    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if state == .inside {
            print("locationManager didDetermineState OUTSINSIDEIDE for \(region.identifier)");
        }
        if state == .outside {
            print("locationManager didDetermineState OUTSIDE for \(region.identifier)");
        }
        
        if state == .unknown {
            print("locationManager didDetermineState Unknown for \(region.identifier)");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(region.identifier)
        if beaconIdentifier ==  region.identifier {
            
            if beacons.count > 0  {
                
                for beacon in  beacons {
                    
                    if beacon.proximityUUID.uuidString.uppercased() == beaconIdentifier.uppercased() {
                        manager.stopRangingBeacons(in: region)
                        break
                    }
                }
            }
        }
    }
    
    
    func alert(message: String) -> Void {
        let alert = UIAlertController(title:"Debug", message:message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    private func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter in region")
        if beaconIdentifier ==  region.identifier {
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didExitRegion region: CLRegion) {
        print("Exit region")

        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
  
    
}




