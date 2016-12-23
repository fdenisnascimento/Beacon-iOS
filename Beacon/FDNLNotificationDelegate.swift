//
//  FDNLNotificationDelegate.swift
//  Beacon
//
//  Created by Denis Nascimento on 22/12/16.
//  Copyright © 2016 Denis Nascimento. All rights reserved.
//

import UIKit
import UserNotifications

class FDNLNotificationDelegate: NSObject ,UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    
    // Determine the user action
    switch response.actionIdentifier {
    case UNNotificationDismissActionIdentifier:
    print("Dismiss Action")
    case UNNotificationDefaultActionIdentifier:
    print("Default")
    case "Snooze":
    print("Snooze")
    case "Delete":
    print("Delete")
    default:
    print("Unknown action")
    }
    completionHandler()
    }
}






