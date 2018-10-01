//
//  ResultsDettCell
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class ResultsDettCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> ResultsDettCell {
        return tableView.dequeueReusableCell(withIdentifier: "ResultsDettCell", for: indexPath) as! ResultsDettCell
    }
    
    @IBOutlet private var lblRank: MYLabel!
    @IBOutlet private var lblNume: MYLabel!
    @IBOutlet private var lblNome: MYLabel!
    @IBOutlet private var lblClub: MYLabel!
    @IBOutlet private var lblTime: MYLabel!
    @IBOutlet private var lblResu: MYLabel!
    @IBOutlet private var lblQual: MYLabel!
    @IBOutlet private var imageTimer: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblRank.textColor = UIColor.white
        lblRank.layer.masksToBounds = true
        lblRank.layer.cornerRadius = lblRank.frame.size.width / 2
        
        lblNume.textColor = .myBlue
        lblNome.textColor = .myBlue
        lblClub.textColor = .myBlue
        lblTime.textColor = .myBlue
        lblQual.textColor = .myBlue
    }
 
    func resultWithDict(_ dict: JsonDict, isRally:Bool, index: Int) {
        lblNume.text = dict.string("Subscriber.chest_number")
    
        var s = dict.string("Subscriber.SportAssociation.business_name")
        if (s.isEmpty) {
            s = dict.string("Subscriber.association_name")
        }
        lblClub.text = s
    
        s = dict.string("Subscriber.name").capitalized + " " +
            dict.string("Subscriber.last_name").capitalized + " con " +
            dict.string("Subscriber.dog").uppercased()
        lblNome.text = s.removingPercentEncoding
    
        var qualified = ""
        if dict.string("Result.absent") == "1" {
            qualified = Lng("absent")
        }
        else if dict.string("Result.disqualified") == "1" {
            qualified = Lng("disqua")
        }
        
        if qualified.isEmpty {
            lblTime.text = String.init(format: "%.02f", dict.double("Result.time"))
            lblQual.text = dict.string("Result.qualifica")
            lblRank.text = String(index + 1)
            lblRank.backgroundColor = .myBlue
            lblResu.text = self.errors(dict)
            imageTimer.isHidden = false
        }
        else {
            lblTime.text = ""
            lblQual.text = qualified
            lblRank.text = qualified.left(lenght: 1)
            lblRank.backgroundColor = UIColor.gray
            lblResu.text = ""
            imageTimer.isHidden = true
        }
        lblResu.textColor = UIColor.gray

        guard isRally == true else {
            return
        }
        
        lblResu.textColor = .myBlue
        lblResu.textAlignment = NSTextAlignment.center
        lblResu.text = lblQual.text
        lblQual.text = lblTime.text!.isEmpty ? "" :  "Pt. " + dict.string("Result.rally_score")
    }
    
    private func errors(_ dict: JsonDict) -> String {
        var strErr = ""
        if dict.double("Result.tot_penalties") > 0 {
            strErr = Lng("pen") + " " + dict.string("Result.tot_penalties") + " -"
        }
        if dict.int("Result.errors") > 0 {
            if strErr.isEmpty == false {
                strErr += " "
            }
            strErr += Lng("err") + " (" + dict.string("Result.errors") + ")"
        }
        if dict.int("Result.refuses") > 0 {
            if strErr.isEmpty == false {
                strErr += " "
            }
            strErr += Lng("ref") + " (" + dict.string("Result.refuses") + ")"
        }
        return strErr
    }
}
