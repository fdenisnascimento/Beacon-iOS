//
//  ViewController.swift
//  Beacon
//
//  Created by Denis Nascimento on 15/12/16.
//  Copyright © 2016 Denis Nascimento. All rights reserved.
//

import UIKit
import UserNotifications

 class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.addObserver(self, forKeyPath: "handleAppLaunchFromNotification", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleAppLaunchFromNotification() {
       print("handleAppLaunchFromNotification")
    }

}


