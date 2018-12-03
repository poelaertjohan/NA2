//
//  SettingsController.swift
//  Shopping List
//
//  Created by johan poelaert on 03/12/2018.
//  Copyright © 2018 johan poelaert. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import UserNotifications


class SettingsController: UITableViewController {

    @IBOutlet weak var enableNotifications_switch_settings: UISwitch!
    @IBOutlet weak var dateAndTime_datepicker_settings: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //STILL HAVE TO ASK FOR PERMISSIONS TO SHOW NOTIFICATIONS
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.enableNotifications_switch_settings.isOn {
            
            
            let calendar = Calendar.current
            let components = DateComponents(year: 2018, month: 12, day: 03, hour: 17, minute: 10)
            let date = calendar.date(from: components)
            let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "Notification Demo"
            content.subtitle = "Demo"
            content.body = "Notification on specific date!!"
            
            let request = UNNotificationRequest(
                identifier: "identifier",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    print("error")
                    print("error")
                } else {
                    print("success")
                    print("success")
                }
            })
        }
    }
    
    
    
}
