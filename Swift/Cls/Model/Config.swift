//
//  MYHttp.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

struct Config {
    struct Wheel {
        static let backImage = UIImage.init(named: "logo")
    }
    struct Http {        
        struct HttpData {
            var url = ""
            var key = ""
        }
        static let base = HttpData.init(url: "http://www.csencinofilia.it/mobile/",
                                        key: "ap8g9L3UuxkxXpNDr7vUZbLjY8gQLv27VdCvXTeWbNq")
        static let soft = HttpData.init(url: "http://software.csencinofilia.it/mobile/",
                                        key: "ap8g9L3UuxkxXpNDr7vUZbLjY8gQLv27VdCvXTeWbNq")
        static let printJson = false
    }
    struct Date {
        static let fmtDb = "dd-MM-yyyy HH:mm"
    }

}

