//
//  RecurringDaysTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/24/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class RecurringDaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var switchDay: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchDay(_ sender: UISwitch) {
    }

}
