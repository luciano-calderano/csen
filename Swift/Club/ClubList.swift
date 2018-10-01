//
//  ClubList.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import MessageUI
import LcLib

class ClubList: MyViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var txtSrch: UITextField!
    
    private var numPage = 1
    private var maxRecords = 25
    private var lastPage = false
    private var strRegionId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func headerOptionButtonTapped() {
        let ctrl = ListaRegioniCtrl ()
        ctrl.delegate = self
        navigationController?.show(ctrl, sender: self)
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("associations-list")
        request.json = [
            "page"       : numPage,
            "maxrecords" : maxRecords,
            "region_id"  : strRegionId,
            "lang_id"    : Lng("iso"),
            "src"        : txtSrch!.text!,
            "img_width"  : 80,
            "img_height" : 80,
            "img_crop"   : 2,
            "img_bg"     : "FFFFFF",
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        let arr = resultDict.array("associations")
        
        lastPage = (arr.count < maxRecords) ? true : false
        if (numPage == 1) {
            dataArray.removeAll()
        }
        dataArray += arr
        tableView.reloadData()
    }
    
// MARK:- Search
    
    @IBAction func btnSrch() {
        numPage = 1
        loadData()
        txtSrch?.resignFirstResponder()
    }
}

// MARK:- MFMailComposeViewControllerDelegate

extension ClubList: MFMailComposeViewControllerDelegate  {
    func configuredMailComposeViewController(_ dest: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([dest])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if (error != nil) {
            showSendMailErrorAlert((error?.localizedDescription)!)
        }
        controller.popViewController(animated: true)
    }
    
    private func showSendMailErrorAlert(_ title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK:- UIScrollViewDelegate

extension ClubList: UIScrollViewDelegate  {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (lastPage == true) {
            return
        }
        let lastRow = (tableView.indexPath(for: tableView.visibleCells.last!)?.row)! + 1
        if lastRow == numPage * maxRecords {
            numPage += 1
            loadData()
        }
    }
}

// MARK:- UITableViewDelegate - UITableViewDataSource

extension ClubList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ClubListCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- ListaRegioniCtrlDelegate

extension ClubList: ListaRegioniCtrlDelegate {
    func listaRegioniDidSelected(_ sender: ListaRegioniCtrl, regionId: String, regionName: String) {
        numPage = 1
        strRegionId = regionId
        header.title = regionName
        loadData()
    }
}

// MARK:- ClubListCellDelegate

extension ClubList: ClubListCellDelegate {
    func clubListCell(_ sender: ClubListCell, phoneTapped value: String) {
        let s: String = "telprompt://" + value
        UIApplication.shared.open(URL(string: s)!, options: [:], completionHandler: nil)
    }
    
    func clubListCell(_ sender: ClubListCell, emailTapped value: String) {
        let mailComposeViewController = configuredMailComposeViewController(value)
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert("Could Not Send Email")
        }
    }
}

