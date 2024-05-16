//
//  Basher Announce.swift
//  BasherBar
//
//  Created by Neal Watkins on 2024/5/16.
//

import Foundation
import UserNotifications

extension Basher {
    
    /// compare scores in two games and send notifications of major changes
    func announce(_ old: Cricket.Game, _ new: Cricket.Game) {
        if old.innNo != new.innNo {
            announce(innings: new.current)
        } else {
            if old.score?.runs != new.score?.runs {
                announce(score: new.score)
            }
        }
        announce(wickets: new.commentary.wickets(since: old.commentary.last))
        
    }
    
    func announce(score: Cricket.Score?) {
        guard let score else { return }
        announce(title: "\(score.text)", detail: "")
    }
    
    func announce(innings: Cricket.Game.Innings?) {
        guard let innings else { return }
        let team = innings.team
        announce(title: "New Innings", detail: "\(team.name) Batting.")
    }
    
    
    func announce(wickets: [String]?) {
        guard let wickets else { return }
        for wicket in wickets {
            announce(title: "Wicket!", detail: "\(wicket)")
        }
    }

    func announce(title: String, detail: String) {
        requestPermissionForNotifications()
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = detail

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func requestPermissionForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
