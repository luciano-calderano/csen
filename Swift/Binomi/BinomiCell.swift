//
//  BinomiCell.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BinomiCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> BinomiCell {
        return tableView.dequeueReusableCell(withIdentifier: "BinomiCell", for: indexPath) as! BinomiCell
    }
    
    var dicData: JsonDict = [:] {
        didSet {
            showData (dicData.dictionary("Binomial"))
        }
    }

    @IBOutlet private var binomial: MYLabel!
    @IBOutlet private var microchip: MYLabel!
    @IBOutlet private var name: MYLabel!
    @IBOutlet private var dog: MYLabel!

    private func showData(_ dic: JsonDict) -> Void {
        binomial.text = dic.string("binomial")
        microchip.text = dic.string("microchip")
        name.text = dic.string("name") + " " + dic.string("last_name")
        dog.text = dic.string("dog").capitalized
    }
}
