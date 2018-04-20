//
//  SliderNormalTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/20/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SliderNormalTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
