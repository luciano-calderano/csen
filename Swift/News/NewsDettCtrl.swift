//
//  NewsDettCtrl.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 03/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class NewsDettCtrl: MyViewController {
    class func instanceFromSb (_ sb: UIStoryboard!) -> NewsDettCtrl {
        return sb.instantiateViewController(withIdentifier: "NewsDettCtrl") as! NewsDettCtrl
    }

    var idNews = ""
    
    @IBOutlet private var web:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        let request =  MYHttpRequest.base("article")
        request.json = [
            "article_id" : self.idNews,
            "img_width"  : 256,
            "img_height" : 256,
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
        let dict = resultDict.dictionary("article.Frontarticle")
        var str = "<p align=center><font face='Verdana, Arial, Helvetica, sans-serif' color='#01509D' size='2'>"
        str += "<b>"
        str += dict.string("title")
        str += "<br>"
        str += dict.string("autore") + " " + dict.string("online_datetime")
        str += "</font></p>"
        str += "<hr>"
        str += dict.string("description")
        self.web?.loadHTMLString(str, baseURL: URL.init(string: "http://www.csencinofilia.it"))
    }
}
