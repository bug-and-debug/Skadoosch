//
//  AboutTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textViewAbout: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textViewAbout.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            self.textViewAbout.resignFirstResponder()
            return false
        }
        if textView.text.characters.count +  (text.characters.count - range.length) <= 1000 {
            return true
        }
        else {
            Utilities.showBanner(title: "", message: "You have reached the limit of 1000 characters.", image: nil, backgroundColor: Constants.appColor.green)
            return false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewAbout.text = ""
        self.textViewAbout.textColor = Constants.appColor.blue.dark
    }

}
