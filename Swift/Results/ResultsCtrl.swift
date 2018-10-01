//
//  ResultsCell
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class ResultsCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!
    
    var numPage = 1
    var maxRecords = 50
    var areaId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        header.hideOption = Challenge.ChalData.typeName.isEmpty
        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("challenges-results")
        request.json = [
            "page"          : numPage,
            "maxrecords"    : maxRecords,
            "type"          : Challenge.ChalData.key,
            "challenge_type": Challenge.ChalData.typeName,
            "challenge_area": self.areaId,
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        dataArray = resultDict.array("results")
        tableView.reloadData()
    }

    override func headerOptionButtonTapped() {
        let ctrl = AreaCtrl ()
        ctrl.delegate = self
        navigationController?.show(ctrl, sender: self)
    }

}

// MARK:- table view

extension ResultsCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResultsCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ResultsCell
        
        UIGraphicsBeginImageContextWithOptions(cell.frame.size, false, 0)
        cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let dic = dataArray[indexPath.row] as! JsonDict
        if Challenge.ChalData.typeName.isEmpty {
            Challenge.shared.setChallengeWithType(dic.string("SoftwareCompetition.type"))
        }
        
        let ctrl = ResultsTypeCtrl.Instance()
        ctrl.headerImage = image
        ctrl.competitionId = dic.int("SoftwareCompetition.id")
        navigationController?.show(ctrl, sender: self)
    }
}

// MARK:-

extension ResultsCtrl: AreaCtrlDelegate {
    func areaCtrl(_ sender: AreaCtrl, didSelectedAreaId id: String) {
        areaId = id
        loadData()
    }
}

