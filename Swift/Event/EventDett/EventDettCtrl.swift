//
//  EventDettCtrl.m
//  CSEN Cinofilia
//
//  Created by Luciano Calderano on 13/01/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

import UIKit
import LcLib

class EventDettCtrl: MyViewController {
    var dicData = [String: Any]()
    @IBOutlet private var btnSign: UIButton!
    @IBOutlet private var scroll: UIScrollView!
    
    var eventDettSubview: EventDettSubview?
    
    class func Instance () -> EventDettCtrl {
        let sb = UIStoryboard.init(name: "Event", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "EventDettCtrl") as! EventDettCtrl
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        header.title = dicData.string("title")
        
        eventDettSubview = (storyboard?.instantiateViewController(withIdentifier: "EventDettSubview") as! EventDettSubview)
        scroll.addSubview(eventDettSubview!.view)
        eventDettSubview!.update(dicData)
        
        loadEventId(dicData.string("id"))
        btnSign.isHidden = User.shared.userType == User.UserType.Club
    }
    
    override func viewDidLayoutSubviews() {
        var rect = eventDettSubview!.view.frame
        rect.size.height = 1000
        eventDettSubview!.view.frame = rect
        scroll.contentSize = eventDettSubview!.view.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventDettSubview!.view.frame = scroll.frame
        checkUserType()
    }
    
    func loadEventId(_ strId: String) {
        let size = UIScreen.main.bounds.size
        let request =  MYHttpRequest.base("event-details")
        request.json = [
            "event_id"  : strId,
            "img_width" : size.width,
            "img_height": size.height,
            "img_crop"  : 2,
            "img_bg"    : "FFFFFF"
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        eventDettSubview!.update(resultDict.dictionary("event.Frontevent"))
        
        if btnSign.isHidden == true {
            return
        }
        btnSign.isEnabled = false
        let d = Date()
        
        let dIni = dicData.string("subscription_start").toDate(withFormat: Config.Date.fmtDb)
        var result:ComparisonResult?
        result = d.compare(dIni!)
        if (result == ComparisonResult.orderedAscending) {
            return
        }
        
        let dFin = dicData.string("subscription_end").toDate(withFormat: Config.Date.fmtDb)
        result = d.compare(dFin!)
        if (result == ComparisonResult.orderedDescending) {
            return
        }
        btnSign.isEnabled = true
    }
    
    func checkUserType() {
        btnSign.tag = 0
        let s = dicData.string("subscription_state")
        if s.isEmpty {
            if User.shared.userType == User.UserType.Athl {
                btnSign.setTitle(Lng("subscribe"), for: .normal)
                btnSign.backgroundColor = .myGreen
            }
            else {
                btnSign.setTitle(Lng("subsMustLoginBefore"), for: .normal)
                btnSign.tag = 99
            }
        }
        else {
            btnSign.setTitle(Lng("unsubscribe"), for: .normal)
            btnSign.backgroundColor = .myRed
        }
    }
        
    @IBAction func btnSign(_ sender: UIButton) {
        if btnSign.tag == 99 {
            let ctrl = UserLoginCtrl.Instance()
            navigationController?.show(ctrl, sender: self)
        }
        else {
            let ctrl = EventSubsCtrl.Instance()
            ctrl.eventId = dicData.int("id")
            navigationController?.show(ctrl, sender: self)
        }
    }
}
