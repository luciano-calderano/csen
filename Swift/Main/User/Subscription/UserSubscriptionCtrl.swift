//
//  BinomiCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class UserSubscriptionCtrl: MyViewController {
    class func Instance () -> UserSubscriptionCtrl {
        let sb = UIStoryboard.init(name: "User", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "UserSubscriptionCtrl") as! UserSubscriptionCtrl
    }
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let dicUser = User.shared.getUserProfile()
        let request =  MYHttpRequest.base("list-reservations")
        request.json = [
            "athlete_id" : dicUser.string("Athlete.id")
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        dataArray = resultDict.array("subscribed_events")
        tableView.reloadData()
    }
}

    // MARK:- table view

extension UserSubscriptionCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserSubscriptionCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK:-

class UserSubscriptionCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> UserSubscriptionCell {
        return tableView.dequeueReusableCell(withIdentifier: "UserSubscriptionCell", for: indexPath) as! UserSubscriptionCell
    }
    var dicData: JsonDict = [:] {
        didSet {
            showData(dicData)
        }
    }
    
    @IBOutlet private var bin: MYLabel!
    @IBOutlet private var tit: MYLabel!
    @IBOutlet private var loc: MYLabel!
    @IBOutlet private var dat: MYLabel!
    @IBOutlet private var lev: MYLabel!
    
    
    private func showData(_ dicData: JsonDict) -> Void {
        bin.text = dicData.string("Binomial.binomial") + " " +  dicData.string("Binomial.dog")
        tit.text = dicData.string("Frontevent.title")
        loc.text = dicData.string("Frontevent.place")
        dat.text = dicData.string("Frontevent.event_datetime")
        
        lev.text = dicData.string("Software_level.name") + " " +
            dicData.string("Software_height.name") + " " +
            dicData.string("RallyRank.name") + " " +
            dicData.string("CaniCrossLevel.name") + " " +
            dicData.string("CaniCrossCategory.name")
    }
}
