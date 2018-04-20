//
//  NameTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textFieldName.delegate = self
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldName.resignFirstResponder()
        return false
    }
}
