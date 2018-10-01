//
//  MYHttp.swift
//  Lc
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import Alamofire

extension MYHttpRequest {
    class func base (_ page: String) -> MYHttpRequest {
        return MYHttpRequest.load (Config.Http.base, page)
    }
    
    class func software (_ page: String) -> MYHttpRequest {
        return MYHttpRequest.load (Config.Http.soft, page)
    }
    private class func load (_ config: Config.Http.HttpData, _ page: String) -> MYHttpRequest {
        return MYHttpRequest (config.key, config.url, page)
    }
}

class MYHttpRequest {
    var json = JsonDict() {
        didSet {
            http.parameters = json
            http.parameters["auth_code"] = http.token
        }
    }
    
    private struct dataHttp {
        var type = HTTPMethod.post
        var page = ""
        var url = ""
        var token = ""
        var myWheel: MYWheel?
        var parameters = JsonDict()
    }
    private var http = dataHttp()

    init(_ auth: String, _ url: String, _ page: String) {
        http.url = url + page
        http.page = page
        http.token = auth
    }
    
    // MARK: - Start
    
    func start (_ showWheel: Bool = true, completion: ((Bool, JsonDict) -> ())? = nil) {
        startWheel(true, show: showWheel)
        printJson(json)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        manager.request(http.url, method: http.type, parameters: http.parameters).responseJSON { response in
            if response.result.isSuccess {
                let dict = response.result.value as! JsonDict
                completion! (true, dict)
                self.printJson(dict)
            }
            self.startWheel(false, show: showWheel)
        }
    }
    
    // MARK: - private
    
    fileprivate func printJson (_ json: JsonDict) {
        if Config.Http.printJson {
            print("\n[ \(http.page) ]\n\(json)\n------------")
        }
    }
    
    fileprivate func startWheel(_ start: Bool, show: Bool = true, inView: UIView = UIApplication.shared.keyWindow!) {
        guard show else {
            return
        }
        if start {
            http.myWheel = MYWheel()
            http.myWheel?.start(inView)
        }
        else {
            http.myWheel?.stop()
            http.myWheel = nil
        }
    }
    
}

