//
//  AppDelegate.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanito. All rights reserved.
//

import UIKit
import LcLib

typealias JsonDict = Dictionary<String, Any>
func Lng(_ key: String) -> String {
    return MYLang.value(key)
}
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MYLang.setup(langListCodes: ["en", "it"], langFileName: "Lang.txt")
        return true
    }
}


