//
//  UserProfileCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class UserProfileCtrl: MyViewController {
    class func Instance () -> UserProfileCtrl {
        let sb = UIStoryboard.init(name: "User", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "UserProfileCtrl") as! UserProfileCtrl
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mySubsButton: UIButton!
    private var userDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = User.shared.getUserProfile()
        
        switch User.shared.userType {
        case User.UserType.Athl:
            let temp = dict.dictionary("Athlete")
            dataArray = [
                [ "#UsrDesNom", temp.string("first_name") + " " +  temp.string("last_name") ],
                [ "#UsrDesInd", temp.string("address") ],
                [ "#UsrDesLoc", temp.string("city_name")],
                [ "#UsrDesEml", dict.string("Account.email") ],
                [ "" , ""],
                [ "#UsrDesCoF", temp.string("ssn") ],
                [ "#UsrDesDat", temp.string("birthday") ],
                [ "#UsrDesSex", temp.string("gender") ],
            ]
        case User.UserType.Club:
            let temp = dict.dictionary("Sportassociation")
            dataArray = [
                [ "#UsrDesNom", temp.string("business_name") ],
                [ "#UsrDesInd", temp.string("address") ],
                [ "#UsrDesLoc", temp.string("city_name")],
                [ "#UsrDesTel", temp.string("phone") ],
                [ "#UsrDesEml", dict.string("Account.email") ],
                [ "" , ""],
                [ "#UsrDesWeb", temp.string("website") ],
                [ "#UsrDesFac", temp.string("facebook_account") ],
                [ "#UsrDesTwi", temp.string("twitter_account") ],
                ]
            mySubsButton.isHidden = true
        default:
            mySubsButton.isHidden = true
        }
    }
    
    // MARK:- actions
    
    override func headerBackButtonTapped() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func headerOptionButtonTapped() {
        let navi = navigationController!
        self.showAlert("Logout ?", message: "", cancelBlock: nil, okBlock: {
            (UIAlertAction) -> Void in
            User.shared.logout()
            _ = navi.popToRootViewController(animated: true)
        })
    }
    
    @IBAction private func mySubsButtonTapped()  {
        let ctrl = UserSubscriptionCtrl.Instance()
        navigationController?.show(ctrl, sender: self)
    }
}

    // MARK:- table view

extension UserProfileCtrl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserProfileCell.dequeue(tableView, indexPath: indexPath)
        let array = dataArray[indexPath.row] as! [String]
        
        cell.title.title = array[0]
        cell.descr.text = array[1]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- 

class UserProfileCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> UserProfileCell {
        return tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
    }
    
    @IBOutlet var title: MYLabel!
    @IBOutlet var descr: MYLabel!
}


