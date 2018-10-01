//
//  BinomiCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class EventCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var areaId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.hideOption = Challenge.ChalData.typeName.isEmpty
        loadData()
    }
    
    override func headerOptionButtonTapped() {
        let ctrl = AreaCtrl()
        ctrl.delegate = self
        navigationController?.show(ctrl, sender: self)
    }

    func loadData(){
        let request =  MYHttpRequest.base("list-events")
        request.json = [
            "page"           : 1,
            "maxrecords"     : 50,
            "type"           : Challenge.ChalData.key,
            "challenge_type" : Challenge.ChalData.typeName,
            "challenge_area" : areaId,
            "img_width"      : UIScreen.main.bounds.size.width - 10,
            "img_height"     : 80,
            "img_crop"       : 1,
            "img_bg"         : "FFFFFF",
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        dataArray = resultDict.array("events")
        tableView.reloadData()
    }
}

// MARK:- table view delegate

extension EventCtrl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        return cell
    }
}

// MARK:- table view datasource

extension EventCtrl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ctrl = EventDettCtrl.Instance()
        let dict = dataArray[indexPath.row] as! JsonDict
        ctrl.dicData = dict.dictionary("Frontevent")
        navigationController?.show(ctrl, sender: self)
    }
}

// MARK:- select area

extension EventCtrl: AreaCtrlDelegate {
    func areaCtrl(_ sender: AreaCtrl, didSelectedAreaId id: String) {
        areaId = id
        loadData()
    }
}

