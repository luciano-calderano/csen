//
//  EventDettSubview
//  CSEN Cinofilia
//
//  Created by Luciano Calderano on 15/01/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//
import UIKit
import LcLib

class EventDettSubview: UIViewController {
    @IBOutlet private var lblType: MYLabel!
    @IBOutlet private var lblDay: MYLabel!
    @IBOutlet private var lblMonth: MYLabel!
    @IBOutlet private var lblInfo: MYLabel!
    @IBOutlet private var lblPlace: MYLabel!
    @IBOutlet private var lblAddress: MYLabel!
    @IBOutlet private var lblNumReg: MYLabel!
    @IBOutlet private var lblArbitre: MYLabel!
    @IBOutlet private var lblDatIni: MYLabel!
    @IBOutlet private var lblDatFin: MYLabel!
    @IBOutlet private var lblRegolamento: MYLabel!
    @IBOutlet private var lblBus: MYLabel!
    
    @IBOutlet private var viewDate: UIView!
    @IBOutlet private var imvLocandina: UIImageView!
    @IBOutlet private var webView: UIWebView!
    
    private var rectLocandina = CGRect.zero
    private let placeHolder = UIImage(named: "logoKanito")!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblType.layer.masksToBounds = true
        lblType.layer.cornerRadius = 5
        viewDate.layer.cornerRadius = 5
        lblPlace.text = ""
        lblInfo.text = ""
        lblDay.text = ""
        lblMonth.text = ""
        lblNumReg.text = ""
        lblArbitre.text = ""
        lblDatIni.text = ""
        lblDatFin.text = ""
        lblRegolamento.text = ""
        lblBus.text = ""
        lblAddress.text = ""
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
    }
    
    func update(_ dic: JsonDict) {
        imvLocandina.withUrl(dic.string("image"), placeHolder: placeHolder) {
            (result) in
            self.imvLocandina.alpha = result ? 1 : 0.5
        }
//        imvLocandina.imageFromUrl(dic.string("image"))

        imvLocandina.contentMode = UIView.ContentMode.scaleAspectFill
        imvLocandina.layer.masksToBounds = true
        imvLocandina.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.locandinaTap))
        imvLocandina.addGestureRecognizer(tap)
        
        lblBus.text = dic.string("business_name")
        lblPlace.text = dic.string("place")
        
        let eventDate = dic.string("event_datetime").toDate(withFormat: Config.Date.fmtDb)
        lblDay.text = eventDate!.toString(withFormat: "dd")
        lblMonth.text = eventDate!.toString(withFormat: "MMM")
        
        lblNumReg.text = dic.string("subscribed") + "/" + dic.string("max_subscribers")
        lblArbitre.text = dic.string("place")
        
        lblArbitre.text = Lng("arbiters") + ": " + dic.string("arbiters")
        let city = dic.string("city").isEmpty ? "" : " (" + dic.string("city") + ")"
        lblAddress.text = dic.string("address") + city
        
        lblDatIni.text = dic.string("subscription_start")
        lblDatFin.text = dic.string("subscription_end")
        lblRegolamento.text = Lng("runRule") + " " + dic.string("challenge_regulations")
        lblInfo.text = dic.string("contact_info")
        
        if Challenge.ChalData.typeName == Challenge.TypeChal.None.rawValue {
            lblType.backgroundColor = Challenge.shared.getColorForType(dic.string("challenge_type"))
            lblType.text = Challenge.shared.getTitolo(dic.string("challenge_type"))
            viewDate.backgroundColor = lblType.backgroundColor
        }
        else {
            lblType.text = Challenge.ChalData.title
            lblType.backgroundColor = Challenge.ChalData.color
            viewDate.backgroundColor = Challenge.ChalData.color
        }
        webView.loadHTMLString(dic.string("content"), baseURL: nil)
    }
    
    @objc func locandinaTap() {
        let ctrl = UIApplication.shared.keyWindow?.rootViewController
        
        let imvLocandinaFull = UIImageView(image: imvLocandina.image!)
        imvLocandinaFull.frame = CGRect(x: ctrl!.view.center.x, y: ctrl!.view.center.y, width: 0, height: 0)
        imvLocandinaFull.isUserInteractionEnabled = true
        imvLocandinaFull.tag = 100
        imvLocandinaFull.backgroundColor = UIColor.init(r: 244, g: 244, b: 244)
        
        ctrl!.view.addSubview(imvLocandinaFull)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePic))
        imvLocandinaFull.addGestureRecognizer(tap)
        
        imvLocandinaFull.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            imvLocandinaFull.frame = ctrl!.view.bounds
        })
    }
    
    @objc func closePic() {
        let ctrl = UIApplication.shared.keyWindow?.rootViewController
        
        let imv = ctrl!.view.viewWithTag(100)
        UIView.animate(withDuration: 0.3, animations: {
            imv!.frame = CGRect(x: ctrl!.view.center.x, y: ctrl!.view.center.y, width: 0, height: 0)
            
        }, completion: { (true) in
            imv?.removeFromSuperview()
        }) 
    }
}
