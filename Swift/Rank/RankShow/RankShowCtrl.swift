//
//  BinomiCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class RankShowCtrl: MyViewController {
    class func Instance () -> RankShowCtrl {
        let sb = UIStoryboard.init(name: "Rank", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "RankShowCtrl") as! RankShowCtrl
    }

    @IBOutlet private var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var title = ""
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            title = "#rankTitleA"
        case Challenge.TypeChal.Rall.rawValue:
            title = "#rankTitleC"
        case Challenge.TypeChal.Cros.rawValue:
            title = "#rankTitleR"
        default:
            break
        }
        self.header.title = title
    }
}

    // MARK:- table view
    
extension RankShowCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RankShowCell.dequeue(tableView, indexPath: indexPath)
        cell.dicData = dataArray[indexPath.row] as! JsonDict
        cell.posizione = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtdidSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

