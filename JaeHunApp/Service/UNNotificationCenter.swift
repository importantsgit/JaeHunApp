//
//  UNNotificationCenter.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/21.
//

import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert){
        // 내용
        let content = UNMutableNotificationContent()
        content.title = "알람 시간 입니다."
        if alert.text == "" {
            content.body = "알람 시간이 되었습니다."
        } else {
            content.body = alert.text
        }
        content.sound = UNNotificationSound(named: UNNotificationSoundName("sound.m4a"))
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        
        // 특정 시간
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        // 푸쉬 등록
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
