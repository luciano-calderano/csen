//
//  ResultsTypeCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class ResultsTypeCtrl: MyViewController {
    class func Instance () -> ResultsTypeCtrl {
        let sb = UIStoryboard.init(name: "Results", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "ResultsTypeCtrl") as! ResultsTypeCtrl
    }
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var headerImageView: UIImageView!
    
    var headerImage:UIImage? = nil
    var competitionId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.image = headerImage
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("categories-combinations")
        request.json = [
            "challenge_type": Challenge.ChalData.typeName
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        dataArray = resultDict.array("combinations")
        tableView.reloadData()
    }
}

// MARK:- table view

extension ResultsTypeCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dic = dataArray[indexPath.row] as! JsonDict
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        if Challenge.ChalData.typeName == Challenge.TypeChal.Rall.rawValue {
            dic = dic.dictionary("RallyRank")
            cell.textLabel!.text = dic.string("name")
        }
        else {
            cell.textLabel!.text = dic.string("title")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let ctrl = ResultsDettCtrl.Instance()
        ctrl.dicData = dataArray[indexPath.row] as! JsonDict
        ctrl.competitionId = self.competitionId
        navigationController?.show(ctrl, sender: self)
    }
}
