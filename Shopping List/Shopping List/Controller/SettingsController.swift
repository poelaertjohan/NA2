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
            let datePicked = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self.dateAndTime_datepicker_settings.date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: datePicked, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "Shopping List"
            content.subtitle = "Reminder"
            content.body = "This is your reminder to go shopping!"
            
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
