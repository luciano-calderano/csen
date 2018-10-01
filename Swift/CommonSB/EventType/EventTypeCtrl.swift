//
//  EventTypeCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol EventTypeCtrlDelegate {
    func eventTypeDidSelected(_ sender: EventTypeCtrl)
}

class EventButton: UIButton {
    var type = Challenge.TypeChal.None
}

class EventTypeCtrl: MyViewController {
    @IBOutlet private var btnNone: EventButton!
    @IBOutlet private var btnAgil: EventButton!
    @IBOutlet private var btnRall: EventButton!
    @IBOutlet private var btnCros: EventButton!

    var delegate:EventTypeCtrlDelegate?
    var showAllTypes:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button(btnNone, tag: .None)
        button(btnAgil, tag: .Agil)
        button(btnRall, tag: .Rall)
        button(btnCros, tag: .Cros)

        if showAllTypes == false {
            btnNone.isHidden = true
        }
    }
    
    private func button(_ btn:EventButton, tag:Challenge.TypeChal) {
        btn.tag = tag.hashValue
        btn.type = tag
        btn.layer.cornerRadius = 20.0
        btn.setTitle(btn.titleLabel?.text!.toLang(), for: UIControl.State())
    }

    @IBAction func btnClick (_ sender: EventButton) {
        Challenge.shared.type = sender.type
        delegate?.eventTypeDidSelected(self)
    }
    
    @IBAction func kanitoTapped () {
        let s = "itms-apps://itunes.apple.com/it/app/kanito/id875758829?mt=8&uo=4"
        UIApplication.shared.open(URL(string: s)!, options: [:], completionHandler: nil)
    }

}
