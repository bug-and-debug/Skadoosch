//
//  SliderExtendedTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/20/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class SliderExtendedTableViewCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func slider(_ sender: UISlider) {
    }

}
