//
//  HeaderView.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate {
    func headerOptionButtonTapped()
    func headerBackButtonTapped()
}

class HeaderView: UIView {
    @IBInspectable var titolo = "" {
        didSet {
            headerSubView.titleLabel.text = titolo.toLang()
        }
    }
    @IBInspectable var optionIcon: UIImage? {
        didSet {
            if let image = optionIcon {
                headerSubView.optionButton.setBackgroundImage(image, for: .normal)
            }
            optionIconIsHidden = (optionIcon == nil)
        }
    }
    
    var delegate: HeaderViewDelegate? {
        didSet {
            headerSubView.delegate = delegate
        }
    }
    
    var optionIconIsHidden = true {
        didSet {
            headerSubView.optionButton.isHidden = optionIconIsHidden
        }
    }
    
    private let headerSubView = HeaderSubView.Instance() as! HeaderSubView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubviewWithConstraints(headerSubView)
        optionIconIsHidden = (optionIcon == nil)
    }
}

class HeaderSubView: UIView {    
    @IBOutlet var titleLabel: MYLabel!
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    var delegate: HeaderViewDelegate?
    
    @IBAction func backTapped() {
        delegate?.headerBackButtonTapped()
    }
    
    @IBAction func optionButtonTapped() {
        delegate?.headerOptionButtonTapped()
    }
}
