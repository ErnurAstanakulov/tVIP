//
//  AppDelegate.swift
//  DigitalBank
//
//  Created by iosDeveloper on 10/31/16.
//  Copyright © 2016 iosDeveloper. All rights reserved.
//

import UIKit
import DropDown
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        return UIVisualEffectView(effect: blurEffect)
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sessionManager.adapter = AppRequestAdapter()
        
        #if BANKTEST
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")
        #elseif BANKPROD
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Release", ofType: "plist")
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        #endif
        if let filePath = filePath,
            let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        }
        DropDown.startListeningToKeyboard()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        stylizeViews()
        return true
    }
    
    private func stylizeViews() {
        UINavigationBar.appearance().barTintColor = AppColor.green.uiColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    // MARK: - ReLogin
    func gotoAuthScreen() {
        guard let window = window else {
            return
        }
        AppState.sharedInstance.isLoggined = false
        let authVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController")
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: { window.rootViewController = authVC },
                          completion: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        guard let window = window else { return }
        blurEffectView.frame = window.frame
        window.addSubview(blurEffectView)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        blurEffectView.removeFromSuperview()
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if let adapter = sessionManager.adapter as? AppRequestAdapter {
            adapter.notificationToken = fcmToken
        }
        print("RegToken is " + fcmToken)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        guard let aps = userInfo["aps"] as? [String: Any], let alert = aps["alert"] as? [String: Any], let title = alert["title"] as? String else { return }
        let systemVersion = UIDevice.current.systemVersion
        if systemVersion.compare("10.0.0", options: .numeric) == .orderedAscending {
            ToastMessage.show(message: title, closeAfter: 1500)
        }
    }
}

