//
//  Notification.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 16/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UserNotifications
import Foundation

class Notification { 
    
    func requestNotificationAuthorization(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
            
        }
        
        
    }
    
    
    func notification(){
        
        let content = UNMutableNotificationContent()
        
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request =  UNNotificationRequest(identifier: "Sample", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func notificationTask(_ titulo : String,_ subtitulo : String, _ corpo : String,tempo: Double){
        
        let content = UNMutableNotificationContent()
        
        content.title = titulo
        content.subtitle = subtitulo
        content.body = corpo
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: tempo + 10, repeats: false)
        let request =  UNNotificationRequest(identifier: "Task", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
   
    
    
    
    
    
    
    
    
}
