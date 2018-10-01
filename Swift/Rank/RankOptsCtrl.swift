//
//  RankOptsCtrl
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class RankOptsCtrl: MyViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    class func Instance () -> RankOptsCtrl {
        let sb = UIStoryboard.init(name: "Rank", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "RankOptsCtrl") as! RankOptsCtrl
    }
    
    @IBOutlet private var pickOpt1: UIPickerView?
    @IBOutlet private var pickOpt2: UIPickerView?
    @IBOutlet private var lblOpt2: MYLabel?
    
    var year = 0
    var rallySelection = 0
    
    private var arrOpt1 = [Any]()
    private var arrOpt2 = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickOpt1!.layer.borderColor = UIColor.myBlue.cgColor
        pickOpt1!.layer.borderWidth = 1
        pickOpt2!.layer.borderColor = UIColor.myBlue.cgColor
        pickOpt2!.layer.borderWidth = 1
        
        self.showRankWithptionalRallyChallengeSubId (self.rallySelection)
    }
    
    private func showRankWithptionalRallyChallengeSubId (_ idxComp: Int) {
        self.view.isHidden = false
        arrOpt1 = []
        pickOpt1!.reloadAllComponents()
        arrOpt2 = []
        pickOpt2!.reloadAllComponents()
        
        self.loadCateComb()
        
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            self.loadAreaList()
            lblOpt2!.text = Lng("rankArea")
        case Challenge.TypeChal.Rall.rawValue:
            if idxComp == 2 {
                self.loadAreaList()
            }
            lblOpt2!.text = Lng("rankArea")
        case Challenge.TypeChal.Cros.rawValue:
            lblOpt2!.text = Lng("rankTest")
            self.loadTestList()
            
        default:
            break
        }
        lblOpt2!.isHidden = true
        pickOpt2!.isHidden = true
    }
    
    private func loadCateComb () {
        let request =  MYHttpRequest.base("categories-combinations")
        request.json = [
            "challenge_type"    : Challenge.ChalData.typeName,
            "championship"      : 1
        ]
        request.start() { (success, response) in
            if success {
                self.arrOpt1 = response.array("combinations")
                if self.arrOpt1.count > 0 {
                    self.pickOpt1!.reloadAllComponents()
                }
            }
        }
    }
    
    private func loadTestList() {
        let request =  MYHttpRequest.base("tests-list")
        request.json = [
            "challenge_type"    : Challenge.ChalData.typeName,
        ]
        request.start() { (success, response) in
            if success {
                self.arrOpt2 = response.array("tests")
                if self.arrOpt2.count > 0 {
                    self.pickOpt2!.reloadAllComponents()
                    self.lblOpt2!.isHidden = false
                    self.pickOpt2!.isHidden = false
                }
            }
        }
    }
    
    private func loadAreaList () {
        let request =  MYHttpRequest.base("list-areas")
        request.json = [
            "challenge_type"    : Challenge.ChalData.typeName,
        ]
        request.start() { (success, response) in
            let dic = response.dictionary("areas")
            if (dic.count > 0) {
                var arr = [[String]]()
                for s in dic.keys {
                    arr.append([s, dic.string(s)])
                }
                self.arrOpt2 = arr.sorted { $0.description < $1.description }
                self.pickOpt2!.reloadAllComponents()
                self.lblOpt2!.isHidden = false
                self.pickOpt2!.isHidden = false
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerView == pickOpt1) ? arrOpt1.count : arrOpt2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myPickerCell = MyPicker()
        if (pickerView == pickOpt1) {
            let dic = arrOpt1[row] as! JsonDict
            switch Challenge.ChalData.typeName {
            case Challenge.TypeChal.Agil.rawValue:
                myPickerCell.text = dic.string("title")
            case Challenge.TypeChal.Rall.rawValue:
                myPickerCell.text = dic.string("RallyRank.name")
            case Challenge.TypeChal.Cros.rawValue:
                myPickerCell.text = dic.string("title")
            default:
                break
            }
        }
        if (pickerView == pickOpt2) {
            switch Challenge.ChalData.typeName {
            case Challenge.TypeChal.Agil.rawValue:
                let arr = arrOpt2[row] as! [String]
                myPickerCell.text = arr[1]
            case Challenge.TypeChal.Rall.rawValue:
                let arr = arrOpt2[row] as! [String]
                myPickerCell.text = arr[1]
            case Challenge.TypeChal.Cros.rawValue:
                let dic = arrOpt2[row] as! JsonDict
                myPickerCell.text = dic.string("CaniCrossTest.name")
            default:
                break
            }
        }
        
        return myPickerCell
    }
    
    @IBAction private func okTapped () {
        let i1 = pickOpt1!.selectedRow(inComponent: 0)
        let i2 = pickOpt2!.selectedRow(inComponent: 0)
        var strUrl = ""
        var dicJson = [String: Any]()
        switch Challenge.ChalData.typeName {
        case Challenge.TypeChal.Agil.rawValue:
            strUrl = "agilitydog/championship-ranking"
            
            let dic = arrOpt1[i1] as! JsonDict
            let arr = arrOpt2[i2] as! [String]

            dicJson = [
                "year"       : year,
                "level_id"   : dic.string("level_id"),
                "height_id"  : dic.string("height_id"),
                "area"       : arrOpt2.count > 0 ? arr[0] : "",
            ]
            
        case Challenge.TypeChal.Rall.rawValue:
            switch (self.rallySelection) {
            case 0:
                strUrl = "rally-o/generate-italian-cup-classification"
            case 1:
                strUrl = "rally-o/generate-grade-champions-classification"
            case 2:
                strUrl = "rally-o/generate-regional-classification"
            case 3:
                strUrl = "rally-o/generate-promises-classification"
            default:
                break
            }
            
            let dic = arrOpt1[i1] as! JsonDict
            let arr = arrOpt2[i2] as! [String]
            dicJson = [
                "start_year" : year - 1,
                "end_year"   : year,
                "rank_id"    : dic.string("RallyRank.id"),
                "region"     : arrOpt2.count > 0 ? arr[0] : "",
            ]
        case Challenge.TypeChal.Cros.rawValue:
            strUrl = "canicross/generate-classification"
            
            let dic1 = arrOpt1[i1] as! JsonDict
            let dic2 = arrOpt2[i2] as! JsonDict
            
            dicJson = [
                "year"          : year,
                "category_id"   : dic1.string("category_id"),
                "test_id"       : dic2.string("CaniCrossTest.id"),
            ]
        default:
            return
        }
        
        let navi = navigationController!
        let request = MYHttpRequest.software(strUrl)
        request.json = dicJson
        request.start() { (success, response) in
            if success {
                var key = ""
                switch Challenge.ChalData.typeName {
                case Challenge.TypeChal.Agil.rawValue:
                    key = "ranking"
                case Challenge.TypeChal.Rall.rawValue:
                    key = "competitions"
                case Challenge.TypeChal.Cros.rawValue:
                    key = "ranking"
                default:
                    break
                }

                let ctrl = RankShowCtrl.Instance()
                ctrl.dataArray = response.array(key)
                navi.show(ctrl, sender:self)
            }
        }
    }
    
}
