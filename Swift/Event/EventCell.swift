//
//  EventCell.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> EventCell {
        return tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
    }

    private let placeHolder = UIImage.init(named: "logoKanito")!
    var dicData: JsonDict = [:] {
        didSet {
            showData (dicData.dictionary("Frontevent"))
        }
    }
    
    @IBOutlet private var lblTitle: MYLabel!
    @IBOutlet private var lblDay: MYLabel!
    @IBOutlet private var lblMonth: MYLabel!
    @IBOutlet private var lblArea: MYLabel!
    @IBOutlet private var lblPlace: MYLabel!
    @IBOutlet private var lblNumReg: MYLabel!
    @IBOutlet private var lblType: MYLabel!
    @IBOutlet private var lblSubs: MYLabel!
    @IBOutlet private var viewDate: UIView!
    @IBOutlet private var imvLocandina: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblArea.layer.masksToBounds = true
        lblArea.layer.cornerRadius = 5
        lblType.layer.masksToBounds = true
        lblType.layer.cornerRadius = 5
        viewDate.layer.cornerRadius = 5
    }
    
    private func showData(_ dic: JsonDict) -> Void {
        lblPlace.text = dic.string("place")
        lblArea.text = dic.string("challenge_area")
        
        let eventDate = dic.string("event_datetime").toDate(withFormat: Config.Date.fmtDb)
        lblDay.text = eventDate!.toString(withFormat: "dd")
        lblMonth.text = eventDate!.toString(withFormat: "MMM")
        
        lblNumReg.text = Lng("handlers") + " " + dic.string("subscribed") + "/" + dic.string("max_subscribers")
        
        lblTitle.text = dic.string("title")
        
        lblType.text = Challenge.ChalData.title
        if Challenge.ChalData.typeName == Challenge.TypeChal.None.rawValue {
            lblType.backgroundColor = Challenge.shared.getColorForType(dic.string("challenge_type"))
            lblType.text = Challenge.shared.getTitolo(dic.string("challenge_type"))
            viewDate.backgroundColor = lblType.backgroundColor
        }
        else {
            lblType.backgroundColor = Challenge.ChalData.color
            viewDate.backgroundColor = Challenge.ChalData.color
        }
        
        lblSubs.text = Lng("subsAreClosed")
        lblSubs.textColor = .myRed
        imvLocandina.withUrl(dic.string("image"), placeHolder: placeHolder) {
            (result) in
            self.imvLocandina.alpha = result ? 1 : 0.5
        }

        let d = Date()
        
        let dIni = dic.string("subscription_start").toDate(withFormat: Config.Date.fmtDb)
        var result:ComparisonResult?
        result = d.compare(dIni!)
        if (result == ComparisonResult.orderedAscending) {
            return
        }
        
        let dFin = dic.string("subscription_end").toDate(withFormat: Config.Date.fmtDb)
        result = d.compare(dFin!)
        if (result == ComparisonResult.orderedDescending) {
            return
        }
        lblSubs.text = Lng("subsOpen")
        lblSubs.textColor = .myGreen
        
    }
}

