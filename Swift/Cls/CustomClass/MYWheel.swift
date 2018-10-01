//
//  MYWheel.swift
//  Lc
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanitoKanito. All rights reserved.
//

import UIKit

class MYWheel: UIView {
    private let wheel = UIActivityIndicatorView()
//    private var backImage: UIImage?
//    private var backAlpha = 0.15
    
    init(_ autoStart: Bool = false) {
        super.init(frame: UIScreen.main.bounds)
        self.initialize()
        if autoStart {
            self.start()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize () {
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.15) //UIColor.clearColor()
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        container.center = self.center
        container.backgroundColor = .darkGray
        container.alpha = 0.8
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        
        wheel.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        wheel.style = UIActivityIndicatorView.Style.whiteLarge
        wheel.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        
        container.addSubview(wheel)
        
        self.addSubview(container)
    }
    
    func stop () {
        wheel.stopAnimating()
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    func start(_ uiView: UIView = UIApplication.shared.keyWindow!) -> Void {
        self.frame = uiView.bounds
        self.center = uiView.center
        if let backImage = Config.Wheel.backImage {
            let image = UIImageView()
            image.image = backImage
            image.contentMode = .scaleAspectFit
            image.alpha = 0.15
            image.frame = self.bounds
            self.addSubview(image)
            self.sendSubviewToBack(image)
        }
        self.isHidden = false
        uiView.addSubview(self)
        wheel.startAnimating()
    }
}
