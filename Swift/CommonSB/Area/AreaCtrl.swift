//
//  ListaRegioniCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol AreaCtrlDelegate {
    func areaCtrl(_ sender: AreaCtrl, didSelectedAreaId id: String)
}


class AreaCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!
    private var areaDict = [String: Any]()
    
    var delegate:AreaCtrlDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("list-areas")
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
        areaDict = resultDict.dictionary("areas")
        dataArray = Array(self.areaDict.keys.sorted())
        tableView.reloadData()
    }
}

    // MARK:- table view
    
extension AreaCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let key = dataArray[indexPath.row] as? String
        cell.textLabel!.text = self.areaDict.string(key!)
        cell.textLabel!.textAlignment = NSTextAlignment.center
        cell.textLabel!.font = UIFont.mySizeBold(20)
        cell.textLabel!.textColor = .myBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let areaId = dataArray[indexPath.row] as? String {
            delegate?.areaCtrl(self, didSelectedAreaId: areaId)
            _ = navigationController?.popViewController(animated: true)

        }
    }
}
