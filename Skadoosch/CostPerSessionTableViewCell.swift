//
//  CostPerSessionTableViewCell.swift
//  Skadoosch
//
//  Created by Boshko Barac on 7/20/17.
//  Copyright © 2017 Borneagency. All rights reserved.
//

import UIKit

class CostPerSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var constraintHeightViewForSlider: NSLayoutConstraint!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.constraintHeightViewForSlider.constant = 0.0
                
            } else {
                self.constraintHeightViewForSlider.constant = 62
            }
        }
    }
    @IBAction func slider(_ sender: UISlider) {
        self.labelPrice.text = "$ \(slider.value)"

    }

}
