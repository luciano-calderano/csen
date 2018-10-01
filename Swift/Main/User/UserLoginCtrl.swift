//
//  UserCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class UserLoginCtrl: MyViewController {
    class func Instance () -> UserLoginCtrl {
        let sb = UIStoryboard.init(name: "User", bundle: nil)
        return sb.instantiateInitialViewController() as! UserLoginCtrl
    }

    @IBOutlet private var txtUser: UITextField!
    @IBOutlet private var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
            txtUser.text = "jollysa87" ; txtPass.text = "qwerty"
// txtUser.text = "doctormusic78"; txtPass.text = "mojomojo" // email doctormusic78@gmail.com
//            txtUser.text = "jollysa87asso" // asd
// txtUser.text = @"TOVE"; txtPass.text = @"DUST2003"
        #endif
    }

    @IBAction func btnLogin() {
        if txtUser.text!.isEmpty {
            txtUser.becomeFirstResponder()
            return
        }
        if txtPass.text!.isEmpty {
            txtPass.becomeFirstResponder()
            return
        }
        
        let request =  MYHttpRequest.base("login")
        request.json = [
            "username": txtUser.text!,
            "password": txtPass.text!,
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
            else {
                self.showError("Server error")
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        if resultDict.int("status") == 0 {
            showError(resultDict.string("error_msg"))
        }
        else {
            let dicUser = resultDict.dictionary("user")
            if dicUser.count == 0 {
                showError("Server error (null user)")
            }
            else {
                User.shared.saveUser(dicUser, name: txtUser.text! as String, pass: txtPass.text!)
                let ctrl = UserProfileCtrl.Instance()
                navigationController?.show(ctrl, sender: self)
            }
        }
    }
    
    func showError(_ errorDesc: String) {
        showAlert(errorDesc, message: "", okBlock: nil)
    }
}

