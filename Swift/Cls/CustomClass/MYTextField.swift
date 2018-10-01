//
//  MYTextField
//  CsenCinofilia
//
//  Created by Luciano Calderano on 03/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MYTextField: UITextField, UITextFieldDelegate {
    @IBOutlet var nextTextField: MYTextField?
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    override internal func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    private func initialize () {
        self.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.nextTextField == nil  {
            self.resignFirstResponder()
        }
        else {
            self.nextTextField?.becomeFirstResponder()
        }
        return true
    }
}
