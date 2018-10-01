//
//  ResultsCell
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> ResultsCell {
        return tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
    }
    
    var dicData: JsonDict = [:] {
        didSet {
            showData (dicData.dictionary ("SoftwareCompetition"))
        }
    }
    @IBOutlet private var lblTitle: MYLabel!
    @IBOutlet private var lblDay: MYLabel!
    @IBOutlet private var lblMonth: MYLabel!
    @IBOutlet private var lblArea: MYLabel!
    @IBOutlet private var lblPlace: MYLabel!
    @IBOutlet private var lblNum: MYLabel!
    @IBOutlet private var lblType: MYLabel!
    @IBOutlet private var viewDate: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblArea.layer.masksToBounds = true
        lblArea.layer.cornerRadius = 5
        lblType.layer.masksToBounds = true
        lblType.layer.cornerRadius = 5
        viewDate.layer.cornerRadius = 5
    }

    private func showData(_ dic: JsonDict) -> Void {
        lblArea.text = dic.string("area").capitalized
        lblTitle.text = dic.string("name")
        lblPlace.text = dic.string("place")
        lblNum.text = Lng("resuPart") + ": " + dic.string("subscribed")
        
        let eventDate = dic.string("dateTime").toDate(withFormat: Config.Date.fmtDb)
        lblDay.text = eventDate!.toString(withFormat: "dd")
        lblMonth.text = eventDate!.toString(withFormat: "MMM")
        
        if Challenge.ChalData.typeName.isEmpty {
            viewDate.backgroundColor = Challenge.shared.getColorForType(dic.string("type"))
            lblType.text = Challenge.shared.getTitolo(dic.string("type"))
        }
        else {
            viewDate.backgroundColor = Challenge.ChalData.color
            lblType.text = Challenge.ChalData.title
        }
        lblType.backgroundColor = viewDate.backgroundColor
    }
}
