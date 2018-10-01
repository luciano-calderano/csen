//
//  MYButton.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 03/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MYButton: UIButton {
    
    var title: String {
        get {
            return self.titleLabel!.text!
        }
        set {
            self.setTitle(newValue.toLang(), for: UIControl.State())
        }
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize () {
        self.backgroundColor = .myBlue
        self.tintColor = UIColor.white
        self.title = (self.titleLabel?.text)!
    }
}


class MYButtonRounded: MYButton {
    @IBInspectable let cornerRadius:CGFloat = 5.0
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeRound()
    }
    
    private func initializeRound () {
        self.layer.cornerRadius = cornerRadius
    }

}
