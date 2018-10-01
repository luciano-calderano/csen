//
//  UIFontExtension.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 28/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

extension UIFont {
    class func mySize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    class func mySizeBold(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
}
