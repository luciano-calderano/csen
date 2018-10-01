//
//  ListaRegioniCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol ListaRegioniCtrlDelegate {
    func listaRegioniDidSelected(_ sender: ListaRegioniCtrl, regionId: String, regionName: String)
}

class ListaRegioniCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!

    var delegate: ListaRegioniCtrlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("list-regions")
        request.json = [ : ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        let dic = [ "Region" : [ "id": "", "name": Lng("AllRegions") ] ]
        dataArray = Array([[dic], resultDict.array("regions")].joined())
        tableView.reloadData()
    }
}

    // MARK: table view
    
extension ListaRegioniCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let dic = dataArray[indexPath.row] as! JsonDict
        cell.textLabel!.text = dic.string("Region.name")
        cell.textLabel!.textAlignment = NSTextAlignment.center
        cell.textLabel!.font = UIFont.mySizeBold(20)
        cell.textLabel!.textColor = .myBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (delegate != nil) {
            let dic = dataArray[indexPath.row] as! JsonDict
            delegate?.listaRegioniDidSelected(self, regionId: dic.string("Region.id"), regionName: dic.string("Region.name"))
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
