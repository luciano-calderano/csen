//
//  ClubListCell.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol ClubListCellDelegate {
    func clubListCell (_ sender: ClubListCell, phoneTapped value: String)
    func clubListCell (_ sender: ClubListCell, emailTapped value: String)
}

class ClubListCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> ClubListCell {
        return tableView.dequeueReusableCell(withIdentifier: "ClubListCell", for: indexPath) as! ClubListCell
    }
    private let placeHolder = UIImage.init(named: "K")!

    var dicData: JsonDict = [:] {
        didSet {
            showData (dicData.dictionary("Sportassociation"))
        }
    }
    
    @IBOutlet private var business_name: UITextView!
    @IBOutlet private var address: UITextView!
    @IBOutlet private var activities: UITextView!
    @IBOutlet private var phone: UITextView!
    @IBOutlet private var email: UITextView!
    @IBOutlet private var imageLogo: UIImageView!

    var delegate: ClubListCellDelegate?
    
    private func showData(_ dic: JsonDict) -> Void {
        business_name.text = dic.string("business_name")
        if (business_name.text.count == 0) {
            business_name.text = dic.string("username")
        }
        business_name.text = business_name.text.capitalized
        
        address.text = dic.string("address") + " " + dic.string("city").replacingOccurrences(of: "\n", with: " ")
        
        activities.text = dic.string("activities")
        phone.text = dic.string("phone")
        email.text = dic.string("email")
        imageLogo.withUrl(dic.string("image"), placeHolder: placeHolder) {
            (result) in
            self.imageLogo.alpha = result ? 1 : 0.65
        }
    }

    @IBAction func btnPhone(_ sender: UIButton) {
        delegate?.clubListCell(self, phoneTapped: phone.text)
    }

    @IBAction func btnEmail(_ sender: UIButton) {
        delegate?.clubListCell(self, emailTapped: email.text)
    }
}

