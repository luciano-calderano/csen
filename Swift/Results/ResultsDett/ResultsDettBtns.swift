//
//  ResultsDettCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
class ResultsDettBtns: UIView {
    @IBOutlet private var button01: UIButton!
    @IBOutlet private var button02: UIButton!
    @IBOutlet private var button03: UIButton!
    
    @IBOutlet private var viewHeight: NSLayoutConstraint?
    
    var btnArray = [UIButton]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnArray = [ button01, button02, button03 ]
        
        var i = 1
        for button in btnArray {
            button.layer.cornerRadius = 5
            button.tag = i
            i += 1
        }
        _ = self.selectButton(button01)
    }
    
    func updateButtonLabel (_ isRally: Bool) {
        self.isHidden = isRally
        if isRally {
            viewHeight?.constant = 0
        }
        else {
            viewHeight?.constant = 50
            loadData()
        }
    }

    func selectButton (_ button: UIButton) -> Int {
        for btn in btnArray {
            btn.backgroundColor = (btn == button) ? .myGreen : .myBlue
        }
        return button.tag
    }

    private func loadData () {
        let request =  MYHttpRequest.base("tests-list")
        request.json = [
            "challenge_type": Challenge.ChalData.typeName
        ]
        request.start(false) { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    func httpResponse(_ resultDict: JsonDict) {
        let array = resultDict.array("tests") as! [[String: Any]]
        if array.count == 0 {
            return
        }
        var keyDic = ""
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            keyDic = "Software_test"
            break
        case Challenge.TypeChal.Cros.rawValue:
            keyDic = "CaniCrossTest"
            break
        default:
            return
        }
        
        for dic in array {
            var button:UIButton?
            switch dic.int(keyDic + ".id") {
            case 1 :
                button = button01
            case 2 :
                button = button02
            case 3 :
                button = button03
            default:
                return
            }
            button?.setTitle(dic.string(keyDic + ".name"), for: UIControl.State())
        }
    }
}
