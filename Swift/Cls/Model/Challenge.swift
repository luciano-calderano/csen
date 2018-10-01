//
//  Challenge.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 08/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import LcLib


class Challenge {
    struct ChalData {
        static var key = "challenge"
        static var typeName = ""
        static var title = ""
        static var color = UIColor.myBlue
    }
    static let shared = Challenge()
    enum TypeChal: String {
        case None = ""
        case Agil = "agility_dog"
        case Rall = "rally_obedience"
        case Cros = "canicross"
    }

    var type = TypeChal.None {
        didSet {
            self.setChallenge(type)
        }
    }
    
    private func setChallenge (_ type: TypeChal) {
        Challenge.ChalData.typeName = type.rawValue
        Challenge.ChalData.title = self.getTitolo(type.rawValue)
        Challenge.ChalData.color = self.getColorForType(type.rawValue)
    }
    
    func getTitolo (_ type: String) -> String {
        switch type {
        case Challenge.TypeChal.Agil.rawValue:
            return Lng("run01")
        case Challenge.TypeChal.Rall.rawValue:
            return Lng("run02")
        case Challenge.TypeChal.Cros.rawValue:
            return Lng("run03")
        default:
            return Lng("run00")
        }
    }
    func getColorForType (_ type: String) -> UIColor {
        switch type {
        case Challenge.TypeChal.Agil.rawValue:
            return .myGreen
        case Challenge.TypeChal.Rall.rawValue:
            return .myRed
        case Challenge.TypeChal.Cros.rawValue:
            return .myOrange
        default:
            return .myBlue
        }
    }
    func setChallengeWithType(_ type: String) {
        switch type {
        case Challenge.TypeChal.Agil.rawValue:
            self.setChallenge( .Agil)
        case Challenge.TypeChal.Rall.rawValue:
            self.setChallenge( .Rall)
        case Challenge.TypeChal.Cros.rawValue:
            self.setChallenge( .Cros)
        default:
            self.setChallenge( .None)
        }
    }
    
    
}
