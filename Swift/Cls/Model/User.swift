//
//  User.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 02/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class User {
    static var shared = User()
    enum UserType: String {
        case None = ""
        case Athl = "athlete"
        case Club = "sport_association"
    }
    
    var userType: UserType {
//        set {
//            self.userType = newValue
//        }
        get {
            return self.getUserType()
        }
    }
    
    private let keyName = "keyName"
    private let keyPass = "keyPass"
    private let keyProf = "keyProf"
    
    private func getUserType() -> UserType {
        let dict = self.getUserProfile()
        if dict.count == 0 {
            return UserType.None
        }
        switch dict.string("Account.type") {
        case UserType.Athl.rawValue:
            return UserType.Athl
        case UserType.Club.rawValue:
            return UserType.Club
        default:
            break
        }
        return UserType.None
    }
    
    func getUserProfile() -> JsonDict {
        let user = UserDefaults.standard.object(forKey: keyProf)
        guard user != nil else {
            return [:]
        }
        return user as! Dictionary
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: keyProf)
    }
    
    func saveUser(_ dict:JsonDict, name:String, pass:String) {
        UserDefaults.standard.setValue(name, forKey: keyName)
        UserDefaults.standard.setValue(pass, forKey: keyPass)
        UserDefaults.standard.setValue(dict, forKey: keyProf)
    }
}

