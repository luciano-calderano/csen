
//  ViewRun_Subs.m
//  CSEN Cinofilia
//
//  Created by Luciano Calderano on 19/01/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

import UIKit

class EventSubsCtrl: MyViewController, UITableViewDelegate, UITableViewDataSource {
    class func Instance () -> EventSubsCtrl {
        let sb = UIStoryboard.init(name: "Event", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "EventSubsCtrl") as! EventSubsCtrl
    }
    
    private enum EventKey:String {
        case binomials_list
        
        case levels_list
        case heights_list
        
        case rally_ranks_list
        
        case canicross_levels_list
        case canicross_categories_list
        case canicross_tests_list
    }
    
    @IBOutlet private var tableView: UITableView!
    
    let userId = User.shared.getUserProfile().int("Account.id")
    var eventId = 0

    var dicHttp = [String: Any]()
    var arrCaniCrossTest = [Int]()
    
    var binomialId = 0
    var agilLevelId = 0
    var agilHeightId = 0
    var rallyRankId = 0
    var crossLeveleId = 0
    var crossCategoryId = 0

    private var eventKey = EventKey.binomials_list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        let request =  MYHttpRequest.base("subscribe-to-event")
        request.json = [
            "type"                  : Challenge.ChalData.key,
            "event_id"              : self.eventId,
            "athlete_id"            : self.userId,
            "binomial_id"           : binomialId,
            "height_id"             : agilHeightId,
            "level_id"              : agilLevelId,
            "rally_rank_id"         : rallyRankId,
            "canicross_level_id"    : crossLeveleId,
            "canicross_category_id" : crossCategoryId,
            "canicross_tests"       : arrCaniCrossTest.count
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }

    func httpResponse(_ resultDict: JsonDict) {
        if resultDict.string("success_msg").isEmpty == false {
            let navi = navigationController!
            self.showAlert(resultDict.string("success_msg"), message: resultDict.string("alert_msg"), okBlock: { (UIAlertAction) in
                _ = navi.popViewController(animated: true)
            })
            return
        }
        
        dicHttp = resultDict
        if (binomialId == 0) {
            header.title = Lng("subsBin")
            eventKey = EventKey.binomials_list
            dataArray = resultDict.array(eventKey.rawValue)
            if resultDict.string("alert_msg").isEmpty == false {
                self.showAlert("", message: resultDict.string("alert_msg"), okBlock:nil)
            }
            tableView.reloadData()
            return
        }
        header.title = Lng("subsCatLev")
        
        switch resultDict.string("challenge_type") {
        case Challenge.TypeChal.Agil.rawValue:
            eventKey = agilLevelId == 0 ? EventKey.levels_list : EventKey.heights_list
            
        case Challenge.TypeChal.Rall.rawValue:
            eventKey = EventKey.rally_ranks_list
            
        case Challenge.TypeChal.Cros.rawValue:
            if crossLeveleId == 0 {
                eventKey = EventKey.canicross_levels_list
            }
            else if crossCategoryId == 0 {
                eventKey = EventKey.canicross_categories_list
            }
            else {
                eventKey = EventKey.canicross_tests_list
            }
        default:
            break
        }
        dataArray = resultDict.array(eventKey.rawValue)
        tableView.reloadData()
        
        if eventKey == EventKey.canicross_tests_list && dataArray.count > 0 {
            self.caniCrossAddButton()
        }
    }
    
    // MARK: - Cani cross
    
    private func caniCrossAddButton() {
        let btn = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50))
        btn.setTitle(Lng("subsTit"), for: UIControl.State())
        btn.setTitleColor(UIColor.white, for: UIControl.State())
        btn.addTarget(self, action: #selector(self.caniCrossDone), for: .touchUpInside)
        btn.backgroundColor = .myBlue
        self.view.addSubview(btn)
    }
    
    @objc func caniCrossDone() {
        if arrCaniCrossTest.count > 0 {
            loadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }

        let dic = dataArray[indexPath.row] as! JsonDict
        
        switch eventKey {
        case EventKey.binomials_list :
            cell!.textLabel!.text = dic.string("Binomial.binomial") + " " + dic.string("Binomial.dog")
            cell!.tag = dic.int("Binomial.id")
        case EventKey.levels_list :
            cell!.textLabel!.text = dic.string("SoftwareLevel.name")
            cell!.tag = dic.int("SoftwareLevel.id")
        case EventKey.heights_list :
            cell!.textLabel!.text = dic.string("SoftwareHeight.name")
            cell!.tag = dic.int("SoftwareHeight.id")
        case EventKey.rally_ranks_list :
            cell!.textLabel!.text = dic.string("RallyRank.name")
            cell!.tag = dic.int("RallyRank.id")
        case EventKey.canicross_levels_list :
            cell!.textLabel!.text = dic.string("CaniCrossLevel.name")
            cell!.tag = dic.int("CaniCrossLevel.id")
        case EventKey.canicross_categories_list :
            cell!.textLabel!.text = dic.string("CaniCrossCategory.name")
            cell!.tag = dic.int("CaniCrossCategory.id")
        case EventKey.canicross_tests_list :
            cell!.textLabel!.text = dic.string("CaniCrossTest.name")
            cell!.tag = dic.int("CaniCrossTest.id")
            cell!.accessoryType = arrCaniCrossTest.contains(cell!.tag) ? .checkmark : .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        
        switch self.eventKey {
        case EventKey.binomials_list :
            binomialId = cell.tag
            
        case EventKey.levels_list :
            agilLevelId = cell.tag
        case EventKey.heights_list :
            agilHeightId = cell.tag
            
        case EventKey.rally_ranks_list :
            rallyRankId = cell.tag
            
        case EventKey.canicross_levels_list :
            crossLeveleId = cell.tag
            eventKey = EventKey.canicross_categories_list
            dataArray = dicHttp.array(eventKey.rawValue)
            if dataArray.count > 0 {
                tableView.reloadData()
                return
            }
        case EventKey.canicross_categories_list :
            crossCategoryId = cell.tag
            
        case EventKey.canicross_tests_list :
            if (arrCaniCrossTest.contains(cell.tag)) {
                arrCaniCrossTest.remove(at: arrCaniCrossTest.index(of: cell.tag)!)
            }
            else {
                arrCaniCrossTest += [cell.tag]
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
            return
        }
        loadData()
    }
}
