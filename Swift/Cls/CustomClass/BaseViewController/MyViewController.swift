//
//  MyViewController.swift
//  CsenCinofilia
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, HeaderViewDelegate {
    @IBOutlet private var containerHeaderView: HeaderView?
    
    var dataArray: Array = [Any]()
    struct HeaderValues {
        var title = ""
        var hideOption = true
    }
    var header = HeaderValues () {
        didSet {
            if let headerView = containerHeaderView {
                headerView.optionIconIsHidden = header.hideOption
                headerView.titolo = header.title
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController!.navigationBar.shadowImage = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerHeaderView?.delegate = self
    }
    
    func backToRoot() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func headerBackButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func headerOptionButtonTapped () {
        print("headerOptionButtonTapped")
    }
}
