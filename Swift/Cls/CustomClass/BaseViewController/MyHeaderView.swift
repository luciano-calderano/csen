//
//  MyViewController.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol MyHeaderViewDelegate {
    func myHeaderOptionButtonTapped()
    func myHeaderBackButtonTapped()
}

class HeaderView: UIView {
    @IBInspectable var titolo = ""
    @IBInspectable var optionIcon: UIImage?
    
    private let myHeaderView = HeaderSubView.Instance() as! HeaderSubView
    
    var delegate: MyHeaderViewDelegate? {
        didSet {
            myHeaderView.delegate = delegate
        }
    }
    
    var headerTitle = "" {
        didSet {
            myHeaderView.titleLabel.text = headerTitle.tryLang()
        }
    }
    
    var optionButtonIsHidden = false {
        didSet {
            myHeaderView.optionButton.isHidden = optionButtonIsHidden
        }
    }
    var optionButtonImage = UIImage() {
        didSet {
            myHeaderView.optionButton.setBackgroundImage(optionButtonImage, for: .normal)
            myHeaderView.optionButton.isHidden = false
        }
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        if let image = optionIcon {
            optionButtonImage = image
        } else {
            optionButtonIsHidden = true
        }
    }
    
//    func load (delegate: MyHeaderViewDelegate? = nil) {
//        self.delegate = delegate
//        if let image = optionIcon {
//            optionButtonImage = image
//        } else {
//            optionButtonIsHidden = true
//        }
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.addSubviewWithConstraints(myHeaderView)
            headerTitle = titolo.tryLang()
//            myHeaderView.addToContainer(self)
            myHeaderView.optionButton.isHidden = true
    }
}

class HeaderSubView: UIView {    
    @IBOutlet var titleLabel: MYLabel!
    @IBOutlet var optionButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    var delegate: MyHeaderViewDelegate?
    
//    func addToContainer(_ container: MyContainerHeaderView) {
//        container.addSubviewWithConstraints(self)
//        titleLabel?.text = container.titolo.tryLang()
//        optionButton?.isHidden = container.optionIcon == nil
//    }
    
    @IBAction func backTapped() {
        delegate?.myHeaderBackButtonTapped()
    }
    
    @IBAction func myHeaderOptionButtonTapped() {
        delegate?.myHeaderOptionButtonTapped()
    }
}
