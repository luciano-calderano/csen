//
//  ResultsDettCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class ResultsDettCtrl: MyViewController, UITableViewDelegate, UITableViewDataSource {
    class func Instance () -> ResultsDettCtrl {
        let sb = UIStoryboard.init(name: "Results", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "ResultsDettCtrl") as! ResultsDettCtrl
    }
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var buttonView: ResultsDettBtns!
    
    var dicData = [String: Any]()
    var competitionId = 0
    var rankId01 = ""
    var rankId02 = ""
    var testId = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue, Challenge.TypeChal.Cros.rawValue:
            buttonView.updateButtonLabel(false)
        case Challenge.TypeChal.Rall.rawValue:
            header.hideOption = true
            buttonView.updateButtonLabel(true)
        default:
            break
        }
        
        if Challenge.ChalData.typeName.isEmpty {
            header.title = Challenge.shared.getTitolo(self.dicData.string("type"))
        }
        else {
            header.title = Challenge.ChalData.title
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
    }
    func loadData(){
        var dic = [
            "competition_id" : self.competitionId
        ]
        var page = ""
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            page = "agilitydog/competition-results"
            dic["test_id"]     = self.testId
            dic["level_id"]    = self.dicData.int("level_id")
            dic["height_id"]   = self.dicData.int("height_id")
        case Challenge.TypeChal.Cros.rawValue:
            page = "canicross/competition-results"
            dic["test_id"]     = self.testId
            dic["level_id"]    = self.dicData.int("level_id")
            dic["category_id"] = self.dicData.int("category_id")
        case Challenge.TypeChal.Rall.rawValue:
            page = "rally-obedience/competition-results"
            dic["rank_id"]     = self.dicData.int("rank_id")
        default:
            return
        }
        let request = MYHttpRequest.software(page)
        request.json = dic
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    private func httpResponse(_ resultDict: JsonDict) {
        dataArray = resultDict.array("ranking_in") + resultDict.array("ranking_out")
        tableView.reloadData()
    }
    
    @IBAction func buttonPressd (_ button: UIButton) {
        self.testId = buttonView.selectButton(button)
        loadData()
    }
    
    // MARK: table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResultsDettCell.dequeue(tableView, indexPath: indexPath)
        cell.resultWithDict(dataArray[indexPath.row] as! JsonDict,
                            isRally: false, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func headerOptionButtonTapped() {
        var dic = [
            "competition_id" : self.competitionId,
            "challenge_type" : Challenge.ChalData.typeName,
        ] as [String : Any]
        
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            dic["test_id"]   = self.testId
            dic["level_id"]  = self.dicData.int("level_id")
            dic["height_id"] = self.dicData.int("height_id")
        case Challenge.TypeChal.Cros.rawValue:
            break
        default:
            return
        }
        let request = MYHttpRequest.software("competition-specifications")
        request.json = dic
        request.start() { (success, response) in
            if success {
                self.httpResponseCompetition(response)
            }
        }
    }
    private func httpResponseCompetition(_ resultDict: JsonDict) {
        if resultDict.count == 0 {
            return
        }
        var msg = ""
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            let dic = resultDict.dictionary("specifications.Specification")
            msg = Lng("arbiter")   + ": " + dic.string("arbiter").capitalized + "\n" +
                  Lng("length")    + ": " + dic.string("length") + " mt.\n" +
                  Lng("obstacles") + ": " + dic.string("obstacles") + "\n" +
                  Lng("sct")       + ": " + dic.string("sct") + "\n" +
                  Lng("speed")     + ": " + dic.string("speed")
        case Challenge.TypeChal.Cros.rawValue:
            let dic = resultDict.dictionary("specifications.Front")
            msg = dic.string("canicross_length") + " mt. / " +
                  dic.string("canicross_track").replacingOccurrences(of: "_", with: " ")
        default:
            return
        }
        self.showAlert(Challenge.ChalData.title, message: msg, okBlock: nil)
    }
}
