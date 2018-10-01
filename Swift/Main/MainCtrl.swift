//
//  UserCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

enum NextSb: String {
    case user = "User"
    case news = "News"
    case evnt = "Event"
    case resu = "Results"
    case rank = "Rank"
    case binm = "Binomi"
    case club = "Club"
}

class MainCtrl : UIViewController {
    private var strStor = ""
    private var strCtrl = ""

    @IBOutlet private var btnNews: UIButton!
    @IBOutlet private var btnRuns: UIButton!
    @IBOutlet private var btnResu: UIButton!
    @IBOutlet private var btnStat: UIButton!
    @IBOutlet private var btnClub: UIButton!
    @IBOutlet private var btnBinm: UIButton!
    @IBOutlet private var btnUser: MYButtonRounded!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.view.backgroundColor = .white
        view.backgroundColor = .white
    }

    @IBAction func btnClick (_ sender: UIButton) {
        var selectEventType = false
        var showAllEventTypes = true
        
        strStor = ""
        strCtrl = ""
        
        switch (sender) {
        case btnUser:
            strStor = NextSb.user.rawValue
            strCtrl = User.shared.userType == User.UserType.None ? "" : "UserProfileCtrl"
        case btnNews:
            strStor = NextSb.news.rawValue
        case btnRuns:
            selectEventType = true
            strStor = NextSb.evnt.rawValue
        case btnResu:
            selectEventType = true
            strStor = NextSb.resu.rawValue
        case btnStat:
            selectEventType = true
            showAllEventTypes = false
            strStor = NextSb.rank.rawValue
        case btnBinm:
            strStor = NextSb.binm.rawValue
        case btnClub:
            strStor = NextSb.club.rawValue
        default:
            return
        }
        if (selectEventType == false) {
            gotoNextViewCtrl()
        }
        else {
            selectRunType(showAllEventTypes)
        }
    }
    
    private func gotoNextViewCtrl () {
        let sb = UIStoryboard (name: strStor, bundle: nil)
        let ctrl = (strCtrl.isEmpty) ? sb.instantiateInitialViewController() :
                                       sb.instantiateViewController(withIdentifier: strCtrl)
        navigationController?.show(ctrl!, sender: self)
    }
    
    private func selectRunType (_ type: Bool) {
        let ctrl = EventTypeCtrl()
        ctrl.delegate = self
        ctrl.showAllTypes = type
        navigationController?.show(ctrl, sender: self)
    }
}

extension MainCtrl : EventTypeCtrlDelegate {
    func eventTypeDidSelected(_ sender: EventTypeCtrl) {
        gotoNextViewCtrl()
    }
}
