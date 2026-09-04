//
//  SnapReminderApp.swift
//  SnapReminder
//
//  Created by Pawan on 29/08/26.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    func application(

        _ application: UIApplication,

        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil

    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        return true

    }
    

}
@main
struct SnapReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
