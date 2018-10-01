//
//  BinomiCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import LcLib

class BinomiCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var txtSrch: UITextField!
    
    var numPage = 1
    var maxRecords = 25
    var lastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSrch!.placeholder = Lng("srch")
        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("binomials-list")
        request.json = [
            "page"       : numPage,
            "maxrecords" : maxRecords,
            "src"        : txtSrch.text!,
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        let arr = resultDict.array("binomials")
        
        lastPage = (arr.count < maxRecords) ? true : false
        if (numPage == 1) {
            dataArray = []
        }
        dataArray += arr
        tableView.reloadData()
    }
    
    // MARK: Search
    
    @IBAction func btnSrch() {
        numPage = 1
        loadData()
        txtSrch?.resignFirstResponder()
    }
}

    // MARK:- UITableViewDelegate
    
extension BinomiCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BinomiCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    // MARK:- UIScrollViewDelegate
    
extension BinomiCtrl: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (lastPage == true) {
            return
        }
        let lastRow = (tableView.indexPath(for: tableView.visibleCells.last!)?.row)! + 1
        if lastRow == self.numPage * self.maxRecords {
            numPage += 1
            loadData()
        }
    }
}

