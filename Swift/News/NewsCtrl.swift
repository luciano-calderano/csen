//
//  NewsCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class NewsCtrl: MyViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var txtSrch: UITextField!
    
    private var numPage = 1
    private var maxRecords = 25
    private var lastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSrch!.placeholder = Lng("srch")
        loadData()
    }
    
    private func loadData(){
        let request =  MYHttpRequest.base("articles")
        request.json = [
            "page"       : numPage,
            "maxrecords" : maxRecords,
            "src"        : txtSrch.text!,
            "img_width"  : 256,
            "img_height" : 256,
            "img_crop"   : 2,
            "img_bg"     : "FFFFFF",
        ]
        
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    private func httpResponse(_ resultDict: JsonDict) {
        let arr = resultDict.array("articles")
        
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

// MARK:- table view
    
extension NewsCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = dataArray[indexPath.row] as! JsonDict
        let ctrl = NewsDettCtrl.instanceFromSb(self.storyboard)
        ctrl.idNews = dict.string("Frontarticle.id")
        navigationController?.show(ctrl, sender: self)
    }
}

// MARK:- UIScrollViewDelegate

extension NewsCtrl: UIScrollViewDelegate {
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

// MARK:-
class NewsCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> NewsCell {
        return tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
    }
    private let placeHolder = UIImage.init(named: "K")!
    var dicData: JsonDict = [:] {
        didSet {
            showData (dicData.dictionary("Frontarticle"))
        }
    }
    
    @IBOutlet private var titolo: MYLabel!
    @IBOutlet private var autore: MYLabel!
    @IBOutlet private var imageview: UIImageView!
    
    func showData(_ dic: JsonDict) -> Void {
        titolo.text = dic.string("title")
        autore.text = dic.string("autore") + " " +
            dic.string("online_datetime")
        
        imageview.withUrl(dic.string("image"), placeHolder: placeHolder) {
            (result) in
            self.imageview.alpha = result ? 1 : 0.5
        }
    }
}

