//
//  AppDelegate.swift
//  Weather
//
//  Created by Nicolas Bolzan on 07/06/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.label]
        return true
    }
}

